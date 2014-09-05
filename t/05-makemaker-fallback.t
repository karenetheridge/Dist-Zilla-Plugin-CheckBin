use strict;
use warnings FATAL => 'all';

use Test::Requires 'Dist::Zilla::Plugin::MakeMaker::Fallback';

use Path::Tiny;
my $code = path('t', '01-basic.t')->slurp_utf8;

$code =~ s/^(.*)'MakeMaker'(.*)$/${1}'MakeMaker::Fallback'${2}\n${1}'ModuleBuild'${2}/m;
$code =~ s/^(.*)'ExtUtils::MakeMaker'(.*)\[MakeMaker\](.*)\K$/\n${1}'Module::Build'${2}\[ModuleBuild\]${3}/m;
$code =~ s/# (build => ignore, # if using ModuleBuild)/$1/;

eval $code;
die $@ if $@;
