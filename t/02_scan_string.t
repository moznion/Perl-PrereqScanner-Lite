#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;
use Perl::PrereqScanner::Lite;

use t::Util;
use Test::More;
use Test::Deep;

my $scanner = Perl::PrereqScanner::Lite->new;

my $got = $scanner->scan_string(t::Util::slurp(catfile($FindBin::Bin, 'resources', 'foo.pl')));
cmp_deeply($got, {
    'strict'       => 0,
    'warnings'     => 0,
    'parent'       => 0,
    'base'         => 0,
    'perl'         => 5.008001,
    'Time::Local'  => 0,
    'Exporter'     => 0,
    'File::Temp'   => 0.12,
    'Fcntl'        => 0,
    'FileHandle'   => 0,
    'Env'          => 0,
    'English'      => 0,
    'Carp'         => 0,
    'Cwd'          => 0,
    'Getopt::Long' => 0,
    'Getopt::Std'  => 0,
    'TieHash'      => 0,
});

done_testing;

