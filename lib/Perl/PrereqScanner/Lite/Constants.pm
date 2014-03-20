package Perl::PrereqScanner::Lite::Constants;
use strict;
use warnings;
use utf8;

use parent qw(Exporter);

our @EXPORT = qw(
    REQUIRE_DECL REQUIRED_NAME NAMESPACE_RESOLVER NAMESPACE
    SEMI_COLON USE_DECL USED_NAME REG_LIST REG_EXP LEFT_PAREN
    RIGHT_PAREN STRING RAW_STRING DOUBLE KEY
);

use constant {
    REQUIRE_DECL       => 65,
    REQUIRED_NAME      => 89,
    NAMESPACE_RESOLVER => 119,
    NAMESPACE          => 120,
    SEMI_COLON         => 100,
    USE_DECL           => 87,
    USED_NAME          => 88,
    REG_LIST           => 140,
    REG_EXP            => 179,
    LEFT_PAREN         => 101,
    RIGHT_PAREN        => 102,
    STRING             => 165,
    RAW_STRING         => 166,
    DOUBLE             => 164,
    KEY                => 115,
};

1;

