use strict;
use warnings FATAL => 'all';

use Test::Requires { 'Dist::Zilla::Plugin::ModuleBuildTiny::Fallback' => '0.006' };

use Path::Tiny;
my $code = path('t', '01-basic.t')->slurp_utf8;

$code =~ s/'MakeMaker'/'ModuleBuildTiny::Fallback'/g;
$code =~ s/ExtUtils::MakeMaker/Module::Build::Tiny/g;
$code =~ s/Makefile.PL/Build.PL/g;

eval $code;
die $@ if $@;
