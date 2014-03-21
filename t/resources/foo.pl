use if $] < 5.009_005, 'MRO::Compat';
use Test::More tests => 4;

use strict;
use warnings;
use Time::Local qw(timelocal);
use Exporter ();
use JSON 2 qw/encode_json/;
use File::Temp 0.1_1 ();
use File::Temp 0.1_2 ();
use v5.8.1;
use parent ("Fcntl", 'FileHandle');
use parent qw/Env English/;
use parent "PerlIO";
use parent 'Opcode';
use base ("Carp", 'Cwd');
use base qw/Getopt::Long Getopt::Std/;
use base "Pod::Checker";
use base 'Pod::Find';
use lib "$FinBin::Bin/../lib";
require TieHash;
require Text::Tabs;
require "Text/Soundex.pm"; # <= should be ignored


1;
