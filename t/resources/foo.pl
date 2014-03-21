use strict;
use warnings;
use Time::Local qw(timelocal);
use Exporter ();
use JSON 2 qw/encode_json/;
use Test::More 0.9_8;
use File::Temp 0.11 ();
use File::Temp 0.12 ();
use v5.8.1;
use parent ("Fcntl", 'FileHandle');
use parent qw/Env English/;
use parent "PerlIO";
use parent 'Opcode';
use base ("Carp", 'Cwd');
use base qw/Getopt::Long Getopt::Std/;
use base "Pod::Checker";
use base 'Pod::Find';
require TieHash;
require Text::Tabs;
require "Text/Soundex.pm"; # <= should be ignored

1;
