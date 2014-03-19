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
    cmp_deeply($got, {
        strict       => 0,
        warnings     => 0,
        'File::Spec' => 0,
        'IO::File'   => 1.08,
    });
};

subtest 'bar.pl' => sub {
    my $got = $scanner->scan_file(catfile($FindBin::Bin, 'resources', 'bar.pl'));
    cmp_deeply($got, {
        strict        => 0,
        warnings      => 0,
        'Time::Local' => 0,
        'Exporter'    => 0,
        'File::Temp'  => 0.12,
    });
};

done_testing;

