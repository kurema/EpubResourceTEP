use Encode;
use File::Copy;
use Win32::Clipboard;

my $clip = Win32::Clipboard();

my @files=glob "articles/c*.txt";
@files=sort {$a cmp $b} @files;

foreach my $file (@files){
  my ($n) = $file=~ /(\d+)/;
  if(!($file =~ /\/c\d+\.txt$/)){next;}
  if(-e "articles/l".$n.".txt"){next;}
  if(-e "articles/c".$n."ou.txt"){next;}
  if(! (-e "articles/u".$n.".txt")){next;}
  
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
  open FILE, "< :encoding(utf8)" ,"articles/u$n.txt";
  my $url=Encode::encode('shiftjis', <FILE>);
  print $url;
  $clip->Set($url);
  close FILE;

  print "\n";
  print "Name:$file ,Size: ".(-s $file)."\n";
  
  print "Like?>";
  my $lcnt=<STDIN>;
  open LIKE, "> ", "articles/l$n.txt";
  if($lcnt=~ /(\d+)/){
    print LIKE $1;
  }else{
    print LIKE "0";
  }
  close(LIKE);    
  print "\n";
}

