package Perl::PrereqScanner::Lite::Moose;
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
            $c->{is_in_reglist_extends} = 1;
            return 1;
        }
        if ($c->{is_in_reglist_extends}) {
            if ($token_type == REG_EXP) {
                for my $_module_name (split /\s+/, $token->data) {
                    if (not defined $c->{modules}->{$_module_name}) {
                        $c->{modules}->{$_module_name} = 0;
                    }
                }
                $c->{is_in_reglist_extends} = 0;
            }
            return 1;
        }

        # For simply list
        # e.g.
        #   extends ('Foo' 'Bar');
        if ($token_type == LEFT_PAREN) {
            $c->{is_in_list_extends} = 1;
            return 1;
        }
        if ($token_type == RIGHT_PAREN) {
            $c->{is_in_list_extends} = 0;
            return 1;
        }
        if ($c->{is_in_list_extends}) {
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
            $c->{is_in_reglist_extends} = 0;
            $c->{is_in_list_extends}    = 0;
            return 1;
        }

        return 1;
    }

    return;
}

1;

