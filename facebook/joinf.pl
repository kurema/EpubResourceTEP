use utf8;
use CGI;
use warnings;

my @files=glob "articles/c*.txt additional/c*.txt";

if(! -d "epub"){mkdir "epub";}
if(! -d "epub/OEBPS"){mkdir "epub/OEBPS";}
if(! -d "epub/OEBPS/Text"){mkdir "epub/OEBPS/Text";}

open (HTML, "> :encoding(utf8)", "epub/OEBPS/Text/main.xhtml") or next;

print HTML <<"EOS";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
<head>
<title></title>
<link href="../Styles/page.css" rel="stylesheet" type="text/css"/>
</head>
<body>
EOS

my %sorthint;
foreach my $file (@files){
  my $filet=$file;
  $filet=~ s/\/c(\d+)\.txt/\/t$1\.txt/;
  
  open (FILET, "< :encoding(utf8)", $filet) or next;
  my $date=<FILET>;
  $date=~ /^(\d+)年(\d+)月(\d+)日\s+(\d+):(\d+) UTC\+(\d+)$/;
  my $datetext=sprintf("%04d/%02d/%02d %02d:%02d",$1,$2,$3,$4,$5);
  $sorthint{$file}=$datetext;
  close(FILET);
}

@files=sort {$sorthint{$b} cmp $sorthint{$a}} @files;
foreach my $file (@files){
  if(! ($file=~ /c(\d+)\.txt$/)){next;}
  my $num=$1;
  my $fileo=$file;
  $fileo=~ s/\/c(\d+)\.txt/\/o$1\.txt/;
  my $fileu=$file;
  $fileu=~ s/\/c(\d+)\.txt/\/u$1\.txt/;
  my $filet=$file;
  $filet=~ s/\/c(\d+)\.txt/\/t$1\.txt/;
  my $filel=$file;
  $filel=~ s/\/c(\d+)\.txt/\/l$1\.txt/;
  my $filea=$file;
  $filea=~ s/\/c(\d+)\.txt/\/a$1\.txt/;
  my $fileh=$file;
  $fileh=~ s/\/c(\d+)\.txt/\/h$1\.txt/;
  
  print HTML "<div class=\"article\" id=\"article$num\">\n";
  
  print HTML "<div class=\"title\">\n<p>\n";
  my $qr="";
  my $url="";
  if(-e $fileu){
    open (FILEU, "< :encoding(cp932)", $fileu) or next;
    $url=<FILEU>;
    close(FILEU);
    if($url eq ""){$url="\n";}
    
    $url=~ s/\?.+$//s;
    $url=~ s/[\0\r\n]//g;
    $url=CGI::escapeHTML($url);

    my $title="";
    if(-e $fileo){
      open (FILEO, "< :encoding(cp932)", $fileo) or next;
      $title=<FILEO>;
      close(FILEO);
      $title=~ s/[\0\r\n]//g;
      $title=CGI::escapeHTML($title);
      
      #system("mkqrimg.exe /O\"epub/OEBPS/QR/$num.bmp\" /T\"$url\" /S1");
    }else{
      $title="記事タイトル不明"
    }
    print HTML "<a href=\"$url\">$title</a>\n";
    $qr= "<img src=\"../QR/$num.png\" />\n";
  }else{
    print HTML "元記事不明";
  }
  print HTML "</p>\n</div>\n";

  print HTML "<div class=\"time\">\n<p>\n";
  open (FILET, "< :encoding(utf8)", $filet) or next;
  while(<FILET>){
    $_=~ s/\0//g;
    $_=~ s/^(\d+)年(\d+)月(\d+)日\s+(\d+):(\d+) UTC\+(\d+)$/$1年$2月$3日/;
    print HTML $_;
  }
  close(FILET);
  print HTML "</p>\n</div>\n";

  print HTML "<div class=\"text\">\n<p>\n";
  open (FILEC, "< :encoding(utf8)", $file) or next;
  my $lastLine="FIRST";
  while(my $txt=<FILEC>){
    $txt=~ s/\0//g;
    if($txt=~ /^…$/ || $txt=~ /^\-+$/ || ($txt=~ /^$/ && $lastLine=~ /^$/)){
      print HTML "\n</p><hr /><p>\n";
    }elsif($txt=~ /^$/){
      print HTML "\n</p>\n<p>\n";
    }else{
      $txt=MakeUrlALink($txt);
      print HTML $txt;
      print HTML "<br />\n";
    }
    $lastLine=$txt;
  }
  close(FILEC);
  print HTML "</p>\n</div>\n";

  if(-e $filea){
    open (FILEA, "< :encoding(utf8)", $filea) or next;
    my $comment_ad=<FILEA>;
    $comment_ad=~ s/\0//g;
    $comment_ad=MakeUrlALink($comment_ad);
    print HTML "<div class=\"additional\">$comment_ad</div>\n";
    close(FILEA);
  }

  if(-e $filel){
    open (FILEL, "< :encoding(utf8)", $filel) or next;
    my $like=<FILEL>;
#    print HTML "<p class=\"like\">&#x1F44D;$like</p>";
    print HTML "<p class=\"like\">$qr<span class=\"like\">$like Like!</span></p>";
#    print HTML "</p>";
    close(FILEL);
  }else{
    print HTML "<p class=\"like\">$qr</p>";
  }
  if($url ne ""){print HTML "<p class=\"link\"><a class=\"url_link\" href=\"$url\">$url</a></p>";}
  
  print HTML "</div>\n";
}
print HTML "</body>\n</html>\n";


sub MakeUrlALink{
  my ($text)=@_;
#  $text=~ s@(https?://[a-zA-Z0-9_/:%#\$&\?\(\)~\.=\+\-]+)(\)?)@<a href="$1">$1</a>$2@g;
  $text=~ s@(https?://[a-zA-Z0-9_/:%#\$&\?\(~\.=\+\-]+)(\)?)@<a href="$1">$1</a>$2@g;
  return $text;
}
