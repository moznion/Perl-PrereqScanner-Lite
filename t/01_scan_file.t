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

subtest 'foo.pl' => sub {
    my $got = $scanner->scan_file(catfile($FindBin::Bin, 'resources', 'foo.pl'));
    cmp_deeply($got, [
        {
            name    => 'strict',
            version => 0,
        },
        {
            name    => 'warnings',
            version => 0,
        },
        {
            name    => 'File::Spec',
            version => 0,
        },
        {
            name    => 'IO::File',
            version => 1.08,
        },
    ]);
};

subtest 'bar.pl' => sub {
    my $got = $scanner->scan_file(catfile($FindBin::Bin, 'resources', 'bar.pl'));
    cmp_deeply($got, [
        {
            name    => 'strict',
            version => 0,
        },
        {
            name    => 'warnings',
            version => 0,
        },
        {
            name    => 'Time::Local',
            version => 0,
        },
        {
            name    => 'Exporter',
            version => 0,
        },
        {
            name    => 'File::Temp',
            version => 0.12,
        },
    ]);
};

done_testing;

