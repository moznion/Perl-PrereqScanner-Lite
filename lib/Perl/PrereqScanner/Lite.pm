package Perl::PrereqScanner::Lite;
use 5.008005;
use strict;
use warnings;
use Compiler::Lexer;
use Class::Accessor::Lite (
    new => 0,
    rw  => [qw/lexer/],
);

our $VERSION = "0.01";

sub new {
    my ($class) = @_;

    bless {
        lexer => Compiler::Lexer->new,
    }, $class;
}

sub scan_script {
    my ($self, $script) = @_;

    my $tokens = $self->lexer->tokenize($script);

    my $module_name    = 0;
    my $module_version = 0;

    my $is_in_reglist = 0;
    my $is_in_usedecl = 0;
    my $is_inherited  = 0;
    my $is_in_list    = 0;

    my @modules;
    for my $token (@$tokens) {
        my $token_name = $token->{name};

        # use Data::Dumper::Concise; warn Dumper($token); # TODO remove

        if ($token_name eq 'RequiredName') {
            # For requiring
            # e.g.
            #   require Foo::Bar;
            push @modules, {
                name    => $token->data,
                version => 0,
            };
            next;
        }

        if ($token_name eq 'UseDecl') {
            $is_in_usedecl = 1;
        }
        elsif ($is_in_usedecl) {
            if ($token_name eq 'Double') {
                # For specifying perl version
                # e.g.
                #   use 5.012;
                push @modules, {
                    name    => 'perl',
                    version => $token->data,
                };
                $is_in_usedecl = 0;
                next;
            }

            if ($token_name eq 'UsedName') {
                $module_name = $token->{data};
                if ($module_name =~ /(?:base|parent)/) {
                    $is_inherited = 1;
                }
                next;
            }

            if ($token_name =~ /Namespace(?:Resolver)?/) {
                $module_name .= $token->{data};
                next;
            }

            if ($token_name eq 'SemiColon') {
                # End of declare of use statement
                push @modules, {
                    name    => $module_name,
                    version => $module_version,
                };

                $module_name    = '';
                $module_version = 0;
                $is_in_reglist  = 0;
                $is_inherited   = 0;
                $is_in_list     = 0;
                $is_in_usedecl  = 0;

                next;
            }

            if ($is_inherited) {
                # Section for parent/base

                # For qw() notation
                # e.g.
                #   use parent qw/Foo Bar/;
                if ($token_name eq 'RegList') {
                    $is_in_reglist = 1;
                }
                elsif ($is_in_reglist) {
                    if ($token_name eq 'RegExp') {
                        for my $_module_name (split /\s+/, $token->data) {
                            push @modules, {
                                name    => $_module_name,
                                version => 0,
                            };
                        }
                        $is_in_reglist = 0;
                    }
                }

                # For simply list
                # e.g.
                #   use parent ('Foo' 'Bar');
                elsif ($token_name eq 'LeftParenthesis') {
                    $is_in_list = 1;
                }
                elsif ($token_name eq 'RightParenthesis') {
                    $is_in_list = 0;
                }
                elsif ($is_in_list) {
                    if ($token_name =~ /\A(?:Raw)?String\Z/) {
                        push @modules, {
                            name    => $token->data,
                            version => 0,
                        };
                    }
                }

                next;
            }

            if ($token_name =~ /\A(?:Raw)?String\Z/) {
                # For module version
                # e.g.
                #   use Foo::Bar '0.0.1';
                if ($token->data =~ /\d+(\.\d+)*/) {
                    $module_version = $token->data;
                }

                next;
            }
        }
    }

    return \@modules;
}

1;
__END__

=encoding utf-8

=head1 NAME

Perl::PrereqScanner::Lite - It's new $module

=head1 SYNOPSIS

    use Perl::PrereqScanner::Lite;

=head1 DESCRIPTION

Perl::PrereqScanner::Lite is ...

=head1 LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

moznion E<lt>moznion@gmail.comE<gt>

=cut

