package t::Util;
use strict;
use warnings;
use utf8;

sub slurp {
    my ($file_path) = @_;

    open my $fh, '<', $file_path;
    do { local $/; <$fh>; };
}

1;

