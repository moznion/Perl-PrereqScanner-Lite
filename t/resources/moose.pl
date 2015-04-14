#!/usr/bin/env perl

use strict;
use warnings;

use Moose;

with 'Env';
extends 'POSIX';
extends "Fnctrl";
extends qw/Getopt::Long Getopt::Std/;
extends ("Carp", 'Cwd');
extends "perlIO", "Opcode";
+{
    with => 'Find::Bin', # Must be ignore
};

no Moose;
