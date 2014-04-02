#!perl

use strict;
use warnings;
use utf8;
use FindBin;
use File::Spec::Functions qw/catfile/;
use Compiler::Lexer;
use Perl::PrereqScanner::Lite;

use t::Util;
use Test::More;
use Test::Deep;

my $lexer = Compiler::Lexer->new({verbose => 1});
my $tokens = $lexer->tokenize(slurp(catfile($FindBin::Bin, 'resources', 'foo.pl')));

my $scanner = Perl::PrereqScanner::Lite->new;

my $got = $scanner->scan_tokens($tokens);
cmp_deeply(get_reqs_hash($got), {
    'strict'       => 0,
    'warnings'     => 0,
    'parent'       => 0,
    'base'         => 0,
    'lib'          => 0,
    'constant'     => 0,
    'aliased'      => 0,
    'perl'         => 'v5.8.1',
    'Time::Local'  => 0,
    'Exporter'     => 0,
    'File::Temp'   => '0.1_2',
    'Fcntl'        => 0,
    'FileHandle'   => 0,
    'Env'          => 0,
    'English'      => 0,
    'Carp'         => 0,
    'Cwd'          => 0,
    'Getopt::Long' => 0,
    'Getopt::Std'  => 0,
    'TieHash'      => 0,
    'Text::Tabs'   => 0,
    'PerlIO'       => 0,
    'Opcode'       => 0,
    'Pod::Checker' => 0,
    'Pod::Find'    => 0,
    'JSON'         => 2,
    'Test::More'   => 0,
    'Perl::PrereqScanner'       => 0,
    'Perl::PrereqScanner::Lite' => 0,
});

done_testing;

