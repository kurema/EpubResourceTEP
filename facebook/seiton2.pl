use Encode;
use File::Copy;

my @files=glob "articles/c*.txt";
@files=sort {$a cmp $b} @files;

foreach my $file (@files){
  my ($n) = $file=~ /(\d+)/;
  if(-e "articles/u$n.txt"){next;}
  
  open FILE, "< :encoding(utf8)" ,$file;
  my $i=0;
  while((my $in=<FILE>) && $i<5){
    print Encode::encode('shiftjis', $in);
    $i++;
  }
  close FILE;

  print "\n";
  open FILE, "< :encoding(utf8)" ,"articles/t$n.txt";
  print Encode::encode('shiftjis', <FILE>);
  close FILE;

  print "\n";
  print "Name:$file ,Size: ".(-s $file)."\n";
  
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
  print "\n";
}

