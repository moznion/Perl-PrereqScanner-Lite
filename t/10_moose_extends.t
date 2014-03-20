#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;
use Perl::PrereqScanner::Lite;

use Test::More;
use Test::Deep;

my $scanner = Perl::PrereqScanner::Lite->new;
$scanner->add_extra_scanner('Moose');

my $got = $scanner->scan_file(catfile($FindBin::Bin, 'resources', 'moose.pl'));
cmp_deeply($got, {
    Carp           => 0,
    Cwd            => 0,
    Fnctrl         => 0,
    "Getopt::Long" => 0,
    "Getopt::Std"  => 0,
    Moose          => 0,
    POSIX          => 0,
    strict         => 0,
    warnings       => 0
});

done_testing;

