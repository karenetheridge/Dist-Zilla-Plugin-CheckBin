use strict;
use warnings FATAL => 'all';

use Test::Requires { 'Dist::Zilla::Plugin::ModuleBuildTiny' => '0.007' };

use Path::Tiny;
my $code = path('t', '01-basic.t')->slurp_utf8;

$code =~ s/'MakeMaker'/'ModuleBuildTiny'/g;
$code =~ s/ExtUtils::MakeMaker/Module::Build::Tiny/g;
$code =~ s/Makefile.PL/Build.PL/g;

eval $code;
die $@ if $@;
