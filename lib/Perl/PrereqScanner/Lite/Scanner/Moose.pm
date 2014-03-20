package Perl::PrereqScanner::Lite::Scanner::Moose;
use strict;
use warnings;
use utf8;
use Perl::PrereqScanner::Lite::Constants;

sub scan {
    my ($class, $c, $token, $token_type) = @_;

    if ($token_type == KEY && $token->data eq 'extends') {
        $c->{is_in_extends} = 1;
        return 1;
    }

    if ($c->{is_in_extends}) {
        # For qw() notation
        # e.g.
        #   extends qw/Foo Bar/;
        if ($token_type == REG_LIST) {
            $c->{is_in_extends_reglist} = 1;
            return 1;
        }
        if ($c->{is_in_extends_reglist}) {
            if ($token_type == REG_EXP) {
                for my $_module_name (split /\s+/, $token->data) {
                    if (not defined $c->{modules}->{$_module_name}) {
                        $c->{modules}->{$_module_name} = 0;
                    }
                }
                $c->{is_in_extends_reglist} = 0;
            }
            return 1;
        }

        # For simply list
        # e.g.
        #   extends ('Foo' 'Bar');
        if ($token_type == LEFT_PAREN) {
            $c->{is_in_extends_list} = 1;
            return 1;
        }
        if ($token_type == RIGHT_PAREN) {
            $c->{is_in_extends_list} = 0;
            return 1;
        }
        if ($c->{is_in_extends_list}) {
            if ($token_type == STRING || $token_type == RAW_STRING) {
                if (not defined $c->{modules}->{$token->data}) {
                    $c->{modules}->{$token->data} = 0;
                }
            }
            return 1;
        }

        # For string
        # e.g.
        #   extends "Foo"
        if ($token_type == STRING || $token_type == RAW_STRING) {
            $c->{modules}->{$token->data} = 0;
            return 1;
        }

        # End of extends
        if ($token_type == SEMI_COLON) {
            $c->{is_in_extends}         = 0;
            $c->{is_in_extends_reglist} = 0;
            $c->{is_in_extends_list}    = 0;
            return 1;
        }

        return 1;
    }

    return;
}

1;

=encoding utf-8

=head1 NAME

Perl::PrereqScanner::Lite::Scanner::Moose - Extra Scanner for Perl::PrereqScanner::Lite

=head1 SYNOPSIS

    use Perl::PrereqScanner::Lite;

    my $scanner = Perl::PrereqScanner::Lite->new;
    $scanner->add_extra_scanner('Moose');

=head1 DESCRIPTION

Perl::PrereqScanner::Lite::Scanner::Moose is the extra scanner for Perl::PrereqScanner::Lite. This scanner supports C<extends> notation for Moose family.

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

