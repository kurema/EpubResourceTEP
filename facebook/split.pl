binmode STDIN,  ":utf8";

my $str = join('', (<STDIN>));
mkdir "split";
$cnt=0;
$str=~ s/<div class="meta">(.+?)<\/div>.*?<div class="comment">(.+?)<\/div>/$cnt++;Save("split\/t".sprintf("%03d", $cnt).".txt",$1);Save("split\/c".sprintf("%03d", $cnt).".html",$2)/sge;

sub Save{
  my ($file,$content)=@_;
  open (FILE, "> :encoding(utf8)",$file) or die "$!";
  print FILE $content;
  close(FILE);
}
