package t::Util;
use strict;
use warnings;
use utf8;
use CPAN::Meta::Requirements;

use parent qw/Exporter/;

our @EXPORT = qw/slurp get_reqs_hash/;

sub slurp {
    my ($file_path) = @_;

    open my $fh, '<', $file_path;
    do { local $/; <$fh>; };
}

sub get_reqs_hash {
    my ($req) = @_;

    CPAN::Meta::Requirements->new->add_requirements($req)->as_string_hash;
}

1;

