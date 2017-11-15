use utf8;
use Encode;

my @files = glob "*.md";
@files = sort {$a cmp $b} @files;
foreach my $file (@files) {
  open (FILE, "< :encoding(utf8)", $file) or next;
  while(<FILE>){
    my $txt=$_;
    $txt =~ s/^\x{FEFF}//;
    $txt =~ s/[\r\n\t]//g;
    if($txt=~ /^##/){
      $txt=~ s/^##\s*//g;
    }elsif($txt=~ /^#/){
      $txt=~ s/^#\s*//g;
      $file=~ /^(\d+)\./;
      close (FILE);
      my $txt_sjis = Encode::encode('Shift_JIS', $txt);
#      print "$1.$txt_sjis.md\n";
      rename $file,"$1.$txt_sjis.md";
      next;
    }
  }
  close (FILE);
}