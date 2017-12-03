use utf8;
use CGI;
use warnings;
use Time::Local;

my @files=glob "articles/c*.txt additional/c*.txt";

if(! -d "epub"){mkdir "epub";}
if(! -d "epub/OEBPS"){mkdir "epub/OEBPS";}
if(! -d "epub/OEBPS/Text"){mkdir "epub/OEBPS/Text";}

open (HTML, "> :encoding(utf8)", "epub/OEBPS/Text/calendar.xhtml") or next;

print HTML <<"EOS";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
<head>
<title></title>
<link href="../Styles/calendar.css" rel="stylesheet" type="text/css"/>
</head>
<body>
<h1>日付索引</h1>
<div class="calendars">
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

my %calendarLink;
foreach my $file (@files){
  if(! ($file=~ /c(\d+)\.txt$/)){next;}
  my @dt=@{$dateInfo{$file}};
  my ($num)=$file=~ /(\d+)/;
  my $key=sprintf("%04d/%02d/%02d",$dt[0],$dt[1],$dt[2]);
  if(!(exists($calendarLink{$key}))){$calendarLink{$key}="main.xhtml#article$num";}
}

$year=2017;
for(my $month=3;$month<=9;$month++){
  print HTML << "EOS";
<table>
  <caption>${year}年${month}月</caption>
  <tr>
    <th>日</th>
    <th>月</th>
    <th>火</th>
    <th>水</th>
    <th>木</th>
    <th>金</th>
    <th>土</th>
  </tr>
EOS
  my $wday = (localtime( timelocal(0, 0, 0, 1, $month - 1, $year) ))[6];
  my @monthDays=(31,28,31,30,31,30,31,31,30,31,30,31);
  $monthDay=$monthDays[$month-1];
  for(my $wcnt=0;$wcnt*7-$wday<$monthDay;$wcnt++){
    print HTML "<tr>\n";
    for(my $w=0;$w<7;$w++){
      my $day=$wcnt*7+$w-$wday+1;
      my $key=sprintf("%04d/%02d/%02d",$year,$month,$day);
      if($day<=0 || $day>$monthDay){$day="";}
      if(exists($calendarLink{$key})){
        print HTML "<td><a href=\"$calendarLink{$key}\">$day</a></td>\n";
      }else{
        print HTML "<td>$day</td>\n";
      }
    }
    print HTML "</tr>\n";
  }
  print HTML "</table>";
}
print HTML "</div></body>\n</html>\n";

sub MakeUrlALink{
  my ($text)=@_;
  $text=~ s@(https?://[a-zA-Z0-9_/:%#\$&\?\(\)~\.=\+\-]+)@<a href="$1">$1</a>@g;
  return $text;
}
