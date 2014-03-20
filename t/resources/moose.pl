#!/usr/bin/env perl

use strict;
use warnings;

use Moose;

extends 'POSIX';
extends "Fnctrl";
extends qw/Getopt::Long Getopt::Std/;
extends ("Carp", 'Cwd');

no Moose;
