use utf8;

my @files = glob "*.md";
@files = sort {$a cmp $b} @files;
foreach my $file (@files) {
  open (FILE, "< :encoding(utf8)", $file) or next;
  print "$file\n";
  while(<FILE>){
    my $txt=$_;
    $txt =~ s/^\x{FEFF}//;
    if($txt=~ /^##/){
      $txt=~ s/^##\s*//g;
      print "## $txt";
    }elsif($txt=~ /^#/){
      $txt=~ s/^#\s*//g;
      print "# $txt";
    }
  }
  close (FILE);
}