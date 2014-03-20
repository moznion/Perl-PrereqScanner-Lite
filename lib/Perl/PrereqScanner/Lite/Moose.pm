package Perl::PrereqScanner::Lite::Moose;
use strict;
use warnings;
use utf8;

sub scan {
    my ($class, $c, $token, $token_name) = @_;

    if ($token_name eq 'Key' && $token->data eq 'extends') {
        $c->{is_in_extends} = 1;
        return 1;
    }

    if ($c->{is_in_extends}) {
        # For qw() notation
        # e.g.
        #   extends qw/Foo Bar/;
        if ($token_name eq 'RegList') {
            $c->{is_in_reglist_extends} = 1;
            return 1;
        }
        if ($c->{is_in_reglist_extends}) {
            if ($token_name eq 'RegExp') {
                for my $_module_name (split /\s+/, $token->data) {
                    if (not defined $c->modules->{$_module_name}) {
                        $c->modules->{$_module_name} = 0;
                    }
                }
                $c->{is_in_reglist_extends} = 0;
            }
            return 1;
        }

        # For simply list
        # e.g.
        #   extends ('Foo' 'Bar');
        if ($token_name eq 'LeftParenthesis') {
            $c->{is_in_list_extends} = 1;
            return 1;
        }
        if ($token_name eq 'RightParenthesis') {
            $c->{is_in_list_extends} = 0;
            return 1;
        }
        if ($c->{is_in_list_extends}) {
            if ($token_name =~ /\A(?:Raw)?String\Z/) {
                if (not defined $c->modules->{$token->data}) {
                    $c->modules->{$token->data} = 0;
                }
            }
            return 1;
        }

        # For string
        # e.g.
        #   extends "Foo"
        if ($token_name =~ /\A(?:Raw)?String\Z/) {
            $c->modules->{$token->data} = 0;
            return 1;
        }

        # End of extends
        if ($token_name eq 'SemiColon') {
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

