use Encode;
use File::Copy;

my @files=glob "split/c*.html";

foreach my $file (@files){
  open FILE, "< :encoding(utf8)" ,$file;
  my $i=0;
  while((my $in=<FILE>) && $i<5){
    print Encode::encode('shiftjis', $in);
    $i++;
  }
  close FILE;
  print "\n";
  print "Name:$file ,Size: ".(-s $file)."\n";
  
  print "c:Copy>";
  my $com=<STDIN>;
  if($com=~ /^c/){
    my ($n) = $file=~ /(\d+)/;
    copy($file,"articles/c$n.txt");
    copy("split/t$n.txt","articles/t$n.txt");

    print "URL>";
    my $url=<STDIN>;
    if($url ne "\n"){
      open URL, "> ", "articles/u$n.txt";
      print URL $url;
      close(URL);

      print "Original Title>";
      my $title=<STDIN>;
      if($title ne "\n"){
        open TITLE, "> ", "articles/o$n.txt";
        print TITLE $title;
        close(TITLE);
      }
    }
  }
}

