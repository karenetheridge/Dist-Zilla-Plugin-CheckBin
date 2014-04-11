use strict;
use warnings FATAL => 'all';

use Test::More;
use if $ENV{AUTHOR_TESTING}, 'Test::Warnings';
use Test::DZil;
use Path::Tiny;

my $tzil = Builder->from_config(
    { dist_root => 't/does-not-exist' },
    {
        add_files => {
            path(qw(source dist.ini)) => simple_ini(
                [ GatherDir => ],
                [ MakeMaker => ],
                [ 'CheckBin' => { command => ['ls'] } ],
            ),
            path(qw(source lib Foo.pm)) => "package Foo;\n1;\n",
        },
    },
);
$tzil->build;

my $build_dir = path($tzil->tempdir)->child('build');
my $file = $build_dir->child('Makefile.PL');
ok(-e $file, 'Makefile.PL created');

my $content = $file->slurp_utf8;
unlike($content, qr/[^\S\n]\n/m, 'no trailing whitespace in generated file');

like($content, qr/^use Devel::CheckBin;\n^check_bin\('ls'\);\n/m, 'code inserted into Makefile.PL');

done_testing;