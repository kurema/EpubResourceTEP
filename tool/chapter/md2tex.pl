print  <<'EOS';
\documentclass[a5j,12pt]{tbook}
\usepackage[pass]{geometry}

\title{倫理と哲学のトピック}
\author{暮間 真}
\date{}

\begin{document}

\maketitle
EOS

while(<STDIN>){
  my $txt=$_;
  
  if($txt=~ /^##/){
    $txt=~ s/^##\s*//g;
    print "\\section{$txt}";
  }elsif($txt=~ /^#/){
    $txt=~ s/^#\s*//g;
    print "\\chapter{$txt}";
  }else{
    print $txt;
  }
}

print "\n\n\\end{document}";