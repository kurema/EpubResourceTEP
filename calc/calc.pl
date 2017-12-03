$MAXNUM=100;
$SINGLEFILENUM=300;

mkdir "out";

open(FILE, "> out/start.xhtml");
print FILE GetHtmlHead();
print FILE "<p><a href=\"".GetRLink(0)."\">START</a></p>";
print FILE "</body></html>";


my $currentFile=GetRFile(-$MAXNUM+1);

open(FILE, "> out/".$currentFile);
print FILE GetHtmlHead();

for(my($i)=-$MAXNUM+1;$i<$MAXNUM;$i++){
if(GetRFile($i) ne $currentFile){
  $currentFile=GetRFile($i);
  print FILE GetHtmlTail();
  open(FILE, "> out/".($currentFile));
  print FILE GetHtmlHead();
}
print FILE  <<"EOS";
<a id="r${i}" class="np"></a>
<table>
<tr>
<td colspan="4">${i}</td>
</tr>
EOS

  print FILE  "<tr>\n";
  print FILE  "<td><a href=\"".GetRLink(0)."\">CE</a></td>\n";
  print FILE  "<td><a href=\"".GetRLink(0)."\">C</a></td>\n";
  print FILE  "<td><a href=\"".GetRLink(int($i/10))."\">BS</a></td>\n";
  print FILE  "<td><a href=\"".GetOLink("d",$i,0)."\">÷</a></td>\n";
  print FILE  "</tr>\n";

  print FILE  "<tr>\n";
  for(my $k=7;$k<=9;$k++){
    print FILE  GetNumberKey($k,$i);
  }
  print FILE  "<td><a href=\"".GetOLink("m",$i,0)."\">×</a></td>\n";
  print FILE  "</tr>\n";

  print FILE  "<tr>\n";
  for(my $k=4;$k<=6;$k++){
    print FILE  GetNumberKey($k,$i);
  }
  print FILE  "<td><a href=\"".GetOLink("s",$i,0)."\">－</a></td>\n";
  print FILE  "</tr>\n";

  print FILE  "<tr>\n";
  for(my $k=1;$k<=3;$k++){
    print FILE  GetNumberKey($k,$i);
  }
  print FILE  "<td><a href=\"".GetOLink("a",$i,0)."\">＋</a></td>\n";
  print FILE  "</tr>\n";

  print FILE  "<tr>\n";
  print FILE  "<td><a href=\"".GetRLink(-$i)."\">±</a></td>\n";
  print FILE  GetNumberKey(0,$i);
  print FILE  "<td colspan=\"2\"><a href=\"".GetRLink($i)."\">＝</a></td>\n";
  print FILE  "</tr>\n";
  
  print FILE  "</table>";
}

print FILE GetHtmlTail();

ShowKeyOp("a");
ShowKeyOp("s");
ShowKeyOp("m");
ShowKeyOp("d");


sub GetNumberKey{
  my($key,$cnum)=@_;
  if($MAXNUM<=(abs($cnum)*10+$key)){
    return "<td><a href=\"".GetRLink($cnum)."\">$key</a></td>\n";
  }else{
    return "<td><a href=\"".GetRLink($cnum>=0?$cnum*10+$key:$cnum*10-$key)."\">$key</a></td>\n";
  }
}
sub GetNumberKeyOp{
  my($key,$op,$pnum,$cnum)=@_;
  if($MAXNUM<=(abs($cnum)*10+$key)){
    return "<td><a href=\"".GetOLink($op,$pnum,$cnum)."\">$key</a></td>\n";
  }else{
    return "<td><a href=\"".GetOLink($op,$pnum,($cnum>=0?$cnum*10+$key:$cnum*10-$key))."\">$key</a></td>\n";
  }
}

sub ShowKeyOp{
my ($op)=@_;

my $currentFile=GetOFile($op,-$MAXNUM+1,-$MAXNUM+1);
open(FILE, "> out/".$currentFile);
print FILE GetHtmlHead();

for(my($i)=-$MAXNUM+1;$i<$MAXNUM;$i++){
for(my($j)=-$MAXNUM+1;$j<$MAXNUM;$j++){
if(GetOFile($op,$i,$j) ne $currentFile){
  $currentFile=GetOFile($op,$i,$j);
  print FILE GetHtmlTail();
  open(FILE, "> out/".($currentFile));
  print FILE GetHtmlHead();
}


print FILE  <<"EOS";
<a id="o${i}${op}${j}" class="np"></a>
<table>
<tr>
<td colspan="4">${j}</td>
</tr>
EOS
  my $result=0;
  my $key="";
  if($op eq "a"){$result=$i+$j;$key="＋";}
  elsif($op eq "s"){$result=$i-$j;$key="－";}
  elsif($op eq "m"){$result=$i*$j;$key="×";}
  elsif($op eq "d"){$result=$j==0?0:int($i/$j);$key="÷";}

  print FILE  "<tr>\n";
  print FILE  "<td><a href=\"".GetRLink(0)."\">CE</a></td>\n";
  print FILE  "<td><a href=\"".GetOLink($op,$i,0)."\">C</a></td>\n";
  print FILE  "<td><a href=\"".GetOLink($op,$i,int($j/10))."\">BS</a></td>\n";
  print FILE  "<td><a href=\"".GetOLink("d",$i,$j)."\">÷</a></td>\n";
  print FILE  "</tr>\n";

  print FILE  "<tr>\n";
  for(my $k=7;$k<=9;$k++){
    print FILE  GetNumberKeyOp($k,$op,$i,$j);
  }
  print FILE  "<td><a href=\"".GetOLink("m",$i,$j)."\">×</a></td>\n";
  print FILE  "</tr>\n";

  print FILE  "<tr>\n";
  for(my $k=4;$k<=6;$k++){
    print FILE  GetNumberKeyOp($k,$op,$i,$j);
  }
  print FILE  "<td><a href=\"".GetOLink("s",$i,$j)."\">－</a></td>\n";
  print FILE  "</tr>\n";

  print FILE  "<tr>\n";
  for(my $k=1;$k<=3;$k++){
    print FILE  GetNumberKeyOp($k,$op,$i,$j);
  }
  print FILE  "<td><a href=\"".GetOLink("a",$i,$j)."\">＋</a></td>\n";
  print FILE  "</tr>\n";

  print FILE  "<tr>\n";
  print FILE  "<td><a href=\"".GetOLink($op,$i,-$j)."\">±</a></td>\n";
  print FILE  GetNumberKeyOp(0,$op,$i,$j);
  if(abs($result)<$MAXNUM){
    print FILE  "<td colspan=\"2\"><a href=\"".GetRLink($result)."\">＝</a></td>\n";
  }else{
    print FILE  "<td colspan=\"2\"><a href=\"#overflow\">＝</a></td>\n";
  }
  print FILE  "</tr>\n";
  print FILE  "<tr>\n";
  print FILE  "<td colspan=\"4\">$i$key$j＝$result</td>\n";
  print FILE  "</tr>\n";
  print FILE  "</table>";
}
}
print FILE GetHtmlTail();
}

sub GetHtmlTail{
  return "<a id=\"overflow\" class=\"np\"></a>\n<h1>ERROR</h1>\n<p>Overflow.</p>\n<p><a href=\"".GetRLink(0)."\">OK</a></p>\n</body></html>\n";
}

sub GetHtmlHead{
return <<"EOS";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>

<html lang="ja" xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
<head>
<title>Calc</title>
<style type="text/css">
table{
width:100vw;
height:100vh;
text-align: center;
table-layout: fixed;
}
table,td,th {
border-collapse: collapse;
border:1px solid black;
}
h1,p{text-align: center;}
a.np{page-break-before: always !important;}
a, a:link, a:visited, a:link, a:active{
text-decoration: none !important;
color:black;
}
table td{font-size: 10vmin !important;}
</style></head>
<body>
EOS
}

sub GetRFile{
  my ($num)=@_;
  return "r".int(($num+$MAXNUM)/$SINGLEFILENUM).".xhtml";
}


sub GetRLink{
  my ($num)=@_;
  return GetRFile($num)."#r".$num;
}

sub GetOFile{
  my($op,$pnum,$cnum)=@_;
  return $op.int((($pnum+$MAXNUM)*$MAXNUM*2+($cnum+$MAXNUM))/$SINGLEFILENUM).".xhtml";
}

sub GetOLink{
  my($op,$pnum,$cnum)=@_;
  return GetOFile($op,$pnum,$cnum)."#o$pnum$op$cnum";
}
