use strict;
use warnings FATAL => 'all';

use Test::Requires { 'Dist::Zilla::Plugin::ModuleBuildTiny::Fallback' => '0.006' };

use Path::Tiny;
my $code = path('t', '01-basic.t')->slurp_utf8;

$code =~ s/'MakeMaker'/'ModuleBuildTiny::Fallback'/g;
$code =~ s/ExtUtils::MakeMaker/Module::Build::Tiny/g;
$code =~ s/Makefile.PL/Build.PL/g;
$code =~ s/# build prereqs go here/build => \{ requires => \{ 'Module::Build::Tiny' => ignore \} \},/
    if eval { Dist::Zilla::Plugin::ModuleBuildTiny->VERSION('999') }; # adjust later

eval $code;
die $@ if $@;
