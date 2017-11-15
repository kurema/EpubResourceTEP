use utf8;
use Encode;

if(! -d "epub"){mkdir "epub";}
if(! -d "epub/OEBPS"){mkdir "epub/OEBPS";}
if(! -d "epub/OEBPS/Text"){mkdir "epub/OEBPS/Text";}

open (NAVXTHML, "> :encoding(utf8)", "epub/OEBPS/Text/nav.xhtml") or die "unable to create nav.xhtml";
print NAVXTHML <<'EOS';
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" lang="en" xml:lang="en">
<head>
  <meta charset="utf-8" />
  <link href="../Styles/sgc-nav.css" rel="stylesheet" type="text/css"/></head>
<body epub:type="frontmatter">
  <nav epub:type="toc" id="toc">
    <h1>目次</h1>
    <ol>
EOS
open (CONTENTOPF, "> :encoding(utf8)", "epub/OEBPS/content.opf") or die "unable to create content.opf";
print CONTENTOPF <<'EOS';
<?xml version="1.0" encoding="utf-8"?>
<package version="3.0" unique-identifier="BookId" xmlns="http://www.idpf.org/2007/opf">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:identifier id="BookId">urn:uuid:aae6c455-9463-45a1-b826-a02d9f7a0c6e</dc:identifier>
    <dc:language>ja-jp</dc:language>
    <dc:title>倫理と哲学のトピック</dc:title>
    <meta name="cover" content="cover-image" />
  </metadata>
  <manifest>
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
    <item href="coverImage.png" id="cover-image" media-type="image/png" />
EOS
my $opfSpine="";
open (TOCNCX, "> :encoding(utf8)", "epub/OEBPS/toc.ncx") or die "unable to create toc.ncx";
print TOCNCX <<"EOS";
<?xml version="1.0" encoding="utf-8"?>
<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">
  <head>
    <meta name="dtb:uid" content="urn:uuid:aae6c455-9463-45a1-b826-a02d9f7a0c6e" />
    <meta name="dtb:depth" content="0" />
    <meta name="dtb:totalPageCount" content="0" />
    <meta name="dtb:maxPageNumber" content="0" />
  </head>
<docTitle>
   <text>倫理と哲学のトピック</text>
</docTitle>
<navMap>
EOS

my $navCnt=0;
my @dirs= glob "*";
my $sectionCount=1;
@dirs = sort {$a cmp $b} @dirs;
foreach my $dir (@dirs){
  my @files = glob "$dir/*.md";
  if(! -d $dir){next;}
  my ($chaptext)=$dir =~ /^\d+\.(.+)$/;
  if ($chaptext eq ""){next;}
  $navCnt++;
  my $chaptextDecoded=Encode::decode("shift-jis",$chaptext);
#  print "\\chapter{".Encode::encode('utf-8',Encode::decode("shift-jis",$chaptext))."}\n";
#  print "\\chapter{".Encode::encode('utf-8',Encode::decode("utf-8",$chaptext))."}\n";
  my $sectionHtmlRel="Text/Section$sectionCount.xhtml";
  my $sectionHtml="epub/OEBPS/$sectionHtmlRel";
  open (HTML, "> :encoding(utf8)", $sectionHtml) or next;
  print NAVXTHML "<li><a href=\"../$sectionHtmlRel\">$chaptextDecoded</a>\n<ol>";
  print CONTENTOPF <<"EOS";
    <item id="Section${sectionCount}.xhtml" href="${sectionHtmlRel}" media-type="application/xhtml+xml"/>
EOS
  $opfSpine.="    <itemref idref=\"Section$sectionCount.xhtml\"/>\n";
  print TOCNCX GetTocNavPoint("nav".$navCnt,$navCnt,$sectionHtmlRel,$chaptextDecoded);
  $sectionCount++;
  
  print HTML <<"EOS";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
<head>
<title></title>
<link href="../Styles/page.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<h1>${chaptextDecoded}</h1>
EOS
  
  @files = sort {$a cmp $b} @files;
  
  my $isPOpen=0;
  foreach my $file (@files) {
    if($file eq "out.md"){next;}
    open (FILE, "< :encoding(utf8)", $file) or next;
    my $lastLine="";
    while(<FILE>){
      my $txt=$_;
      $txt =~ s/^\x{FEFF}//;
      $txt =~ s/\?/？/g;
      my $tempLastLine=$txt;
      if($txt=~ /^##/){
        $txt=~ s/^##\s*//g;
        $txt=~ s/[\r\n]//g;
        if($isPOpen>=1){print HTML "</p>";}
        $navCnt++;
        print HTML "\n\n<h3 id=\"nav$navCnt\">$txt</h3>\n<p>";
        print TOCNCX GetTocNavPoint("nav".$navCnt,$navCnt,$sectionHtmlRel."#nav$navCnt",$txt);
        $isPOpen=2;
      }elsif($txt=~ /^#/){
        $txt=~ s/^#\s*//g;
        $txt=~ s/[\r\n]//g;
        if($isPOpen>=1){print HTML "</p>";}
        $navCnt++;
        print HTML "\n\n<h2 id=\"nav$navCnt\">$txt</h2>\n<p>";
        print TOCNCX GetTocNavPoint("nav".$navCnt,$navCnt,$sectionHtmlRel."#nav$navCnt",$txt);
        print NAVXTHML "<li><a href=\"../$sectionHtmlRel#nav$navCnt\">$txt</a></li>\n";
        $isPOpen=2;
      }elsif($isPOpen!=2 && $txt=~ /^$/){
        if($isPOpen>=1){print HTML "</p>";}
        print HTML "\n<p>";
        $isPOpen=2;
      }elsif($txt=~ /^\[PAGEBREAK\]$/){
        if($isPOpen>=1){print HTML "</p>";}
        print HTML "\n<p style=\"page-break-before: always;\">";
        $isPOpen=2;
      }else{
        if($isPOpen>=1){$isPOpen=1;}
        $txt=~ s/([^\da-zA-Z\-\+])([\da-zA-Z\-\+]{1,4})([^\da-zA-Z\-\+])/$1<span class="tcy">$2<\/span>$3/g;
        $txt=~ s/^([\da-zA-Z\-\+]{1,4})([^\da-zA-Z\-\+])/<span class="tcy">$1<\/span>$2/g;
        $txt=~ s/([^\da-zA-Z\-\+])([\da-zA-Z\-\+]{1,4})$/$1<span class="tcy">$2<\/span>/g;
        print HTML $txt;
      }
      $lastLine=$tempLastLine;
    }
    close (FILE);
  }
  print HTML "</p>\n</body>\n</html>";
  close (HTML);
  print NAVXTHML "</ol>\n</li>\n";
}
print TOCNCX <<"EOS";
<navPoint id="section_additonal" playOrder="@{[$navCnt+1]}">
  <navLabel>
    <text>付録</text>
  </navLabel>
  <content src="Text/section_additional.xhtml" />
</navPoint>
</navMap>
</ncx>
EOS
print CONTENTOPF <<"EOS";
    <item id="sgc-nav.css" href="Styles/sgc-nav.css" media-type="text/css"/>
    <item id="page.css" href="Styles/page.css" media-type="text/css"/>
    <item id="nav.xhtml" href="Text/nav.xhtml" media-type="application/xhtml+xml" properties="nav"/>
    <item id="section_additional.xhtml" href="Text/section_additional.xhtml" media-type="application/xhtml+xml"/>
    <item id="section_frontmatter.xhtml" href="Text/section_frontmatter.xhtml" media-type="application/xhtml+xml"/>
    <item id="section_endmatter.xhtml" href="Text/section_endmatter.xhtml" media-type="application/xhtml+xml"/>
    <item id="section_imprint.xhtml" href="Text/section_imprint.xhtml" media-type="application/xhtml+xml"/>
<!--    <item id="formula.tate.svg" href="Images/formula.tate.svg" media-type="image/svg+xml"/>-->
    <item id="formula.tate.png" href="Images/formula.tate.png" media-type="image/png"/>
  </manifest>
  <spine page-progression-direction="rtl" toc="ncx">
    <itemref idref="section_frontmatter.xhtml"/>
    <itemref idref="nav.xhtml"/>
${opfSpine}
    <itemref idref="section_additional.xhtml"/>
    <itemref idref="section_endmatter.xhtml"/>
    <itemref idref="section_imprint.xhtml"/>
  </spine>
  <guide>
    <reference href="Text/nav.xhtml" title="toc" type="toc" />
  </guide>
</package>
EOS

print NAVXTHML <<'EOS';
      <li><a href="../Text/section_additional.xhtml">付録</a></li>
<!--      <li><a href="../Text/section_endmatter.xhtml">後書き</a></li>-->
    </ol>
  </nav>
  <nav epub:type="landmarks" id="landmarks" hidden="">
    <h2>Landmarks</h2>
    <ol>
      <li>
        <a epub:type="toc" href="#toc">Table of Contents</a>
      </li>
    </ol>
  </nav>
</body>
</html>
EOS


sub GetTocNavPoint{
  my ($id,$order,$file,$title)=@_;
  return <<"EOS";
<navPoint id="${id}" playOrder="${order}">
  <navLabel>
    <text>${title}</text>
  </navLabel>
  <content src="${file}" />
</navPoint>
EOS
}
