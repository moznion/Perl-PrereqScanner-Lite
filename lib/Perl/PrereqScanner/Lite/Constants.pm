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
    REQUIRE_DECL       => 68,
    REQUIRED_NAME      => 92,
    NAMESPACE_RESOLVER => 123,
    NAMESPACE          => 124,
    SEMI_COLON         => 103,
    USE_DECL           => 90,
    USED_NAME          => 91,
    REG_LIST           => 144,
    REG_EXP            => 183,
    LEFT_PAREN         => 104,
    RIGHT_PAREN        => 105,
    STRING             => 169,
    RAW_STRING         => 170,
    DOUBLE             => 168,
    KEY                => 119,
};

1;

