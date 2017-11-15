use utf8;
use Encode;


print  <<'EOS';
\documentclass[a5j,10pt]{tbook}
\usepackage[pass]{geometry}

\title{倫理と哲学のトピック}
\author{暮間 真}
\date{}

\nonstopmode

\begin{document}
\maketitle
\tableofcontents

EOS

my @dirs= glob "*";
@dirs = sort {$a cmp $b} @dirs;
foreach my $dir (@dirs){
  my @files = glob "$dir/*.md";
  if(! -d $dir){next;}
  my ($chaptext)=$dir =~ /^\d+\.(.+)$/;
  if ($chaptext eq ""){next;}
  print "\\chapter{".Encode::encode('utf-8',Encode::decode("shift-jis",$chaptext))."}\n";
#  print "\\chapter{".Encode::encode('utf-8',Encode::decode("utf-8",$chaptext))."}\n";
  
  @files = sort {$a cmp $b} @files;
  foreach my $file (@files) {
    if($file eq "out.md"){next;}
    open (FILE, "< :encoding(utf8)", $file) or next;
    while(<FILE>){
      my $txt=$_;
      $txt =~ s/^\x{FEFF}//;
      if($txt=~ /^##/){
        $txt=~ s/^##\s*//g;
        $txt=~ s/[\r\n]//g;
        $txt=Encode::encode('utf-8',$txt);
        print "\\subsection*{$txt}\n";
      }elsif($txt=~ /^#/){
        $txt=~ s/^#\s*//g;
        $txt=~ s/[\r\n]//g;
        $txt=Encode::encode('utf-8',$txt);
        print "\\section*{$txt}\n";
      }else{
        $txt=Encode::encode('utf-8',$txt);
        $txt=~ s/([^\da-zA-Z\-\+])(\d{1,3})([^\da-zA-Z\-\+])/$1\\rensuji{$2}$3/g;
        $txt=~ s/([^\da-zA-Z\-\+])(W)([0-9a-zA-Z\-\+]{1,3})([^\da-zA-Z\-\+])/$1\$$2_\{$3\}\$$4/g;
        print $txt;
      }
    }
    print "\n\n";
    close (FILE);
  }
}

print "\n\n\\end{document}";
