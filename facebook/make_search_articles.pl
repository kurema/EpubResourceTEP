use utf8;
use CGI;
use warnings;
use Time::Local;

my @files=glob "articles/c*.txt additional/c*.txt";

if(! -d "epub"){mkdir "epub";}
if(! -d "epub/OEBPS"){mkdir "epub/OEBPS";}
if(! -d "epub/OEBPS/Text"){mkdir "epub/OEBPS/Text";}

open (HTML, "> :encoding(utf8)", "epub/OEBPS/Text/articles.xhtml") or die;

print HTML <<"EOS";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
<head>
<title></title>
<link href="../Styles/index.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<h1 id="index_articles_title">記事タイトル一覧</h1>
<div class="articles_title">
<ul>
EOS

my %dateInfo;
my %sorthint;
foreach my $file (@files){
  my $filet=$file;
  $filet=~ s/\/c(\d+)\.txt/\/t$1\.txt/;
  
  open (FILET, "< :encoding(utf8)", $filet) or next;
  my $date=<FILET>;
  $date=~ /^(\d+)年(\d+)月(\d+)日\s+(\d+):(\d+) UTC\+(\d+)$/;
  my $datetext=sprintf("%04d/%02d/%02d %02d:%02d",$1,$2,$3,$4,$5);
  $sorthint{$file}=$datetext;
  $dateInfo{$file}=[$1,$2,$3,$4,$5];
  close(FILET);
}

@files=sort {$sorthint{$b} cmp $sorthint{$a}} @files;


foreach my $file (@files){
  if(! ($file=~ /c(\d+)\.txt$/)){next;}
  my @dt=@{$dateInfo{$file}};
  my ($num)=$file=~ /(\d+)/;
  my $date=sprintf("%02d/%02d",$dt[1],$dt[2]);

  my $fileo=$file;
  $fileo=~ s/\/c(\d+)\.txt/\/o$1\.txt/;

  if(-e $fileo){
    open (FILE, "< :encoding(cp932)", $fileo) or next;
    my $title=<FILE>;
    $title=~ s/\0//g;
    $title=CGI::escapeHTML($title);
    close(FILE);
    print HTML "<li><a href=\"main.xhtml#article$num\">$title ($date)</a></li>\n";
  }
}

print HTML << "EOS";
</ul>
</div>
<h1 id="index_articles_text">コメント先頭一覧</h1>
<div class="articles_text">
<ul>
EOS

foreach my $file (@files){
  if(! ($file=~ /c(\d+)\.txt$/)){next;}
  my @dt=@{$dateInfo{$file}};
  my ($num)=$file=~ /(\d+)/;
  my $date=sprintf("%02d/%02d",$dt[1],$dt[2]);

  open (FILE, "< :encoding(utf8)", $file) or next;
  my $title=<FILE>;
  $title=~ s/\0//g;
  close(FILE);
  print HTML "<li><a href=\"main.xhtml#article$num\">$title</a></li>\n";
}

print HTML "</ul></div></body>\n</html>\n";

close(HTML);

sub MakeUrlALink{
  my ($text)=@_;
  $text=~ s@(https?://[a-zA-Z0-9_/:%#\$&\?\(\)~\.=\+\-]+)@<a href="$1">$1</a>@g;
  return $text;
}
