use utf8;


mkdir "epub";
mkdir "epub/OEBPS";
mkdir "epub/OEBPS/Calc";

open (OPF, "> :encoding(utf8)", "epub/OEBPS/content.opf") or die "Cannot make content.opf";

print OPF << "EOS";
<?xml version="1.0" encoding="utf-8"?>
<package version="3.0" unique-identifier="BookId" xmlns="http://www.idpf.org/2007/opf">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:identifier id="BookId">urn:uuid:dc026c59-5df5-4e1f-9a80-81f4eb737954</dc:identifier>
    <dc:language>en</dc:language>
    <dc:title>2-Digit Display Calculator</dc:title>
    <meta name="Sigil version" content="0.9.8" />
    <meta property="dcterms:modified">2017-12-01T02:04:43Z</meta>
  </metadata>
  <manifest>
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
    <item id="sgc-nav.css" href="Styles/sgc-nav.css" media-type="text/css"/>
    <item id="nav.xhtml" href="Text/nav.xhtml" media-type="application/xhtml+xml" properties="nav"/>
EOS

my @files=glob "out/*.xhtml";
foreach my $file (@files){
  my ($f)= $file=~ /\/([^\/]+)$/;
  print OPF "    <item id=\"$f\" href=\"Calc/$f\" media-type=\"application/xhtml+xml\"/>\n";
}

print OPF << "EOS";
  </manifest>
  <spine toc="ncx">
    <itemref idref="start.xhtml"/>
    <itemref idref="nav.xhtml" linear="no"/>
EOS
foreach my $file (@files){
  my ($f)= $file=~ /\/([^\/]+)$/;
  if($f eq "start.xhtml"){next;}
  print OPF "    <itemref idref=\"$f\"/>\n";
}
print OPF << "EOS";
  </spine>
</package>
EOS

system("del epub\\OEBPS\\Calc\\*.xhtml");
system("move out\\*.xhtml epub\\OEBPS\\Calc");


