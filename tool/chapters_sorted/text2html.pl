use utf8;
use Encode;

my @dirs= glob "*";
my $sectionCount=1;
@dirs = sort {$a cmp $b} @dirs;
foreach my $dir (@dirs){
  my @files = glob "$dir/*.md";
  if(! -d $dir){next;}
  my ($chaptext)=$dir =~ /^\d+\.(.+)$/;
  if ($chaptext eq ""){next;}
#  print "\\chapter{".Encode::encode('utf-8',Encode::decode("shift-jis",$chaptext))."}\n";
#  print "\\chapter{".Encode::encode('utf-8',Encode::decode("utf-8",$chaptext))."}\n";
  open (HTML, "> :encoding(utf8)", "out/Section$sectionCount.html") or next;
  $sectionCount++;
  
  print HTML <<'EOS';
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
<head>
<title></title>
</head>
<body>
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
      my $tempLastLine=$txt;
      if($txt=~ /^##/){
        $txt=~ s/^##\s*//g;
        $txt=~ s/[\r\n]//g;
        if($isPOpen>=1){print HTML "</p>";}
        print HTML "\n\n<h2>$txt</h2>\n<p>";
        $isPOpen=2;
      }elsif($txt=~ /^#/){
        $txt=~ s/^#\s*//g;
        $txt=~ s/[\r\n]//g;
        if($isPOpen>=1){print HTML "</p>";}
        print HTML "\n\n<h1>$txt</h1>\n<p>";
        $isPOpen=2;
      }elsif($isPOpen!=2 && $txt=~ /^$/){
        if($isPOpen>=1){print HTML "</p>";}
        print HTML "\n<p>";
        $isPOpen=2;
      }else{
        if($isPOpen>=1){$isPOpen=1;}
        print HTML $txt;
      }
      $lastLine=$tempLastLine;
    }
    close (FILE);
  }
  print HTML "</p>\n</body>\n</html>";
  close (HTML);
}
