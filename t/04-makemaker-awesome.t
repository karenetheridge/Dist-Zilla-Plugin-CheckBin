use strict;
use warnings FATAL => 'all';

use Test::Requires { 'Dist::Zilla::Plugin::MakeMaker::Awesome' => '0.13' };

use Path::Tiny;
my $code = path('t', '01-basic.t')->slurp_utf8;

$code =~ s/'MakeMaker'/'MakeMaker::Awesome'/g;

eval $code;
die $@ if $@;
