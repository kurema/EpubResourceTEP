use utf8;

open (OPF, "> :encoding(utf8)", "epub/OEBPS/content.opf") or die "Cannot make content.opf";

print OPF << "EOS";
<?xml version="1.0" encoding="utf-8"?>
<package version="3.0" unique-identifier="BookId" xmlns="http://www.idpf.org/2007/opf">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:identifier id="BookId">urn:uuid:dc509b58-cb7a-4d33-8b8a-d41f81107d76</dc:identifier>
    <dc:language>ja</dc:language>
    <dc:title>2017年投稿履歴</dc:title>
    <meta property="dcterms:modified">2017-12-01T02:04:43Z</meta>
  </metadata>
  <manifest>
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
    <item id="main.xhtml" href="Text/main.xhtml" media-type="application/xhtml+xml"/>
    <item id="fmatter.xhtml" href="Text/fmatter.xhtml" media-type="application/xhtml+xml"/>
    <item id="imprint.xhtml" href="Text/imprint.xhtml" media-type="application/xhtml+xml"/>
    <item id="articles.xhtml" href="Text/articles.xhtml" media-type="application/xhtml+xml"/>
    <item id="calendar.xhtml" href="Text/calendar.xhtml" media-type="application/xhtml+xml"/>
    <item id="sgc-nav.css" href="Styles/sgc-nav.css" media-type="text/css"/>
    <item id="page.css" href="Styles/page.css" media-type="text/css"/>
    <item id="index.css" href="Styles/index.css" media-type="text/css"/>
    <item id="calendar.css" href="Styles/calendar.css" media-type="text/css"/>
    <item id="nav.xhtml" href="Text/nav.xhtml" media-type="application/xhtml+xml" properties="nav"/>
EOS

my @files=glob "epub/OEBPS/QR/*.png";
foreach my $file (@files){
  my ($num)= $file=~ /(\d+)/;
  print OPF "    <item id=\"QR$num\" href=\"QR/$num.png\" media-type=\"image/png\"/>\n";
}

print OPF << "EOS";
  </manifest>
  <spine toc="ncx">
    <itemref idref="fmatter.xhtml"/>
    <itemref idref="nav.xhtml" linear="no"/>
    <itemref idref="main.xhtml"/>
    <itemref idref="articles.xhtml"/>
    <itemref idref="calendar.xhtml"/>
    <itemref idref="imprint.xhtml"/>
  </spine>
</package>
EOS