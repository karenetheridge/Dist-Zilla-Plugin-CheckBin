use strict;
use warnings FATAL => 'all';

use Test::Requires 'Dist::Zilla::Plugin::MakeMaker::Awesome';

use Path::Tiny;
my $code = path('t', '01-basic.t')->slurp_utf8;

$code =~ s/MakeMaker/MakeMaker::Awesome/;

eval $code;
die $@ if $@;
