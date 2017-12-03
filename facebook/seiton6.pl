use Encode;
use File::Copy;
use Win32::Clipboard;
use utf8;

my $clip = Win32::Clipboard();

my @files=glob "articles/c*.txt";
@files=sort {$a cmp $b} @files;

foreach my $file (@files){
  my ($n) = $file=~ /(\d+)/;
  if(!($file =~ /\/c\d+\.txt$/)){next;}
  if(-e "articles/h".$n.".txt"){next;}
  if(! (-e "articles/u".$n.".txt")){next;}
  
  open FILE, "< :encoding(utf8)" ,$file;
  my $i=0;
  while((my $in=<FILE>) && $i<5){
    print Encode::encode('shiftjis', $in);
    $i++;
  }
  close FILE;

  print "\n";
  if(-e "articles/o$n.txt"){
    print "Title:";
    open FILE, "< :encoding(shiftjis)" ,"articles/o$n.txt";
    print Encode::encode('shiftjis', <FILE>);
    close FILE;
  }

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

  if(-e "articles/c".$n."ou.txt"){
    print "Create?(y/n)>";
    my $key2=<STDIN>;
    if($key2=~ /^y$/){
  my $fileTmp="articles/h$n.txt";
  if(! (-e $fileTmp)){
    open FILE, "> :encoding(utf8)" ,$fileTmp;
    print FILE "元記事を入力してください。";
    close FILE;
    system("start notepad.exe $fileTmp");
  }
    }
  }  

  
  my $fileTmp="articles/a$n.txt";
  if(! (-e $fileTmp)){
    print "Comment if any>";
    my $additional=<STDIN>;
    if(! ($additional=~ /^$/)){
      open FILE, "> :encoding(utf8)" ,$fileTmp;
      print FILE Encode::decode('shiftjis', $additional);
      close FILE;
    }
  }else{
    print ">";
    <STDIN>;
  }
  
  print "\n";
}

