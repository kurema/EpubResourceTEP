use utf8;

my @files = glob "*.md";
@files = sort {$a cmp $b} @files;
foreach my $file (@files) {
  if($file eq "out.md"){next;}
  open (FILE, "< :encoding(utf8)", $file) or next;
  while(<FILE>){
    my $txt=$_;
    $txt =~ s/^\x{FEFF}//;
    print $txt
  }
  print "\n\n";
  close (FILE);
}