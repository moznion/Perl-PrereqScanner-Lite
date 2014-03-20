package Perl::PrereqScanner::Lite;
use 5.008005;
use strict;
use warnings;
use Compiler::Lexer;
use Perl::PrereqScanner::Lite::Constants;

our $VERSION = "0.01";

sub new {
    my ($class) = @_;

    bless {
        lexer          => Compiler::Lexer->new,
        extra_scanners => [],
        modules        => {},
    }, $class;
}

sub add_extra_scanner {
    my ($self, $scanner_name) = @_;

    my $extra_scanner = "Perl::PrereqScanner::Lite::$scanner_name";
    eval "require $extra_scanner"; ## no critic
    push @{$self->{extra_scanners}}, $extra_scanner;
}

sub scan_string {
    my ($self, $string) = @_;

    my $tokens = $self->{lexer}->tokenize($string);
    $self->_scan($tokens);
}

sub scan_file {
    my ($self, $file) = @_;

    open my $fh, '<', $file or die "Cannot open file: $file";
    my $script = do { local $/; <$fh>; };

    my $tokens = $self->{lexer}->tokenize($script);
    $self->_scan($tokens);
}

sub scan_tokens {
    my ($self, $tokens) = @_;
    $self->_scan($tokens);
}

sub scan_module {
    my ($self, $module) = @_;

    require Module::Path;

    if (defined(my $path = Module::Path::module_path($module))) {
        return $self->scan_file($path);
    }
}

sub _scan {
    my ($self, $tokens) = @_;

    my $module_name    = 0;
    my $module_version = 0;

    my $is_in_reglist = 0;
    my $is_in_usedecl = 0;
    my $is_in_reqdecl = 0;
    my $is_inherited  = 0;
    my $is_in_list    = 0;

    for my $token (@$tokens) {
        my $token_type = $token->{type};

        if ($token_type == REQUIRE_DECL) {
            $is_in_reqdecl = 1;
            next;
        }

        if ($is_in_reqdecl) {
            # For requiring

            if ($token_type == REQUIRED_NAME) {
                # e.g.
                #   require Foo;
                if (not defined $self->{modules}->{$token->{data}}) {
                    $self->{modules}->{$token->{data}} = 0;
                }

                $is_in_reqdecl = 0;
                next;
            }

            if ($token_type == NAMESPACE || $token_type == NAMESPACE_RESOLVER) {
                # e.g.
                #   require Foo::Bar;
                $module_name .= $token->{data};
                next;
            }

            if ($token_type == SEMI_COLON) {
                unless ($module_name) {
                    next;
                }

                if (not defined $self->{modules}->{$module_name}) {
                    $self->{modules}->{$module_name} = 0;
                }

                $module_name   = '';
                $is_in_reqdecl = 0;
                next;
            }

            next;
        }

        if ($token_type == USE_DECL) {
            $is_in_usedecl = 1;
            next;
        }

        if ($is_in_usedecl) {
            # For using

            if ($token_type == USED_NAME) {
                # e.g.
                #   use Foo;
                #   use parent qw/Foo/;
                $module_name = $token->{data};
                if ($module_name =~ /(?:base|parent)/) {
                    $is_inherited = 1;
                }
                next;
            }

            if ($token_type == NAMESPACE || $token_type == NAMESPACE_RESOLVER) {
                # e.g.
                #   use Foo::Bar;
                $module_name .= $token->{data};
                next;
            }

            if ($token_type == SEMI_COLON) {
                # End of declare of use statement
                if (!$self->{modules}->{$module_name} || $self->{modules}->{$module_name} < $module_version) {
                    $self->{modules}->{$module_name} = $module_version;
                }

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
                if ($token_type == REG_LIST) {
                    $is_in_reglist = 1;
                }
                elsif ($is_in_reglist) {
                    if ($token_type == REG_EXP) {
                        for my $_module_name (split /\s+/, $token->data) {
                            if (not defined $self->{modules}->{$_module_name}) {
                                $self->{modules}->{$_module_name} = 0;
                            }
                        }
                        $is_in_reglist = 0;
                    }
                }

                # For simply list
                # e.g.
                #   use parent ('Foo' 'Bar');
                elsif ($token_type == LEFT_PAREN) {
                    $is_in_list = 1;
                }
                elsif ($token_type == RIGHT_PAREN) {
                    $is_in_list = 0;
                }
                elsif ($is_in_list) {
                    if ($token_type == STRING || $token_type == RAW_STRING) {
                        if (not defined $self->{modules}->{$token->data}) {
                            $self->{modules}->{$token->data} = 0;
                        }
                    }
                }

                # For string
                # e.g.
                #   use parent "Foo"
                elsif ($token_type == STRING || $token_type == RAW_STRING) {
                    $self->{modules}->{$token->data} = 0;
                }

                next;
            }

            if ($token_type == STRING || $token_type == RAW_STRING || $token_type == DOUBLE) {
                if (!$module_name) {
                    # For specifying perl version
                    # e.g.
                    #   use 5.012;
                    my $perl_version = $token->data;
                    if (!$self->{modules}->{perl} || $self->{modules}->{perl} < $perl_version) {
                        $self->{modules}->{perl} = $perl_version;
                    }
                    $is_in_usedecl = 0;
                }
                else {
                    # For module version
                    # e.g.
                    #   use Foo::Bar '0.0.1';
                    if ($token->data =~ /\d+(\.\d+)*/) {
                        $module_version = $token->data;
                    }
                }

                next;
            }

            next;
        }

        for my $extra_scanner (@{$self->{extra_scanners}}) {
            if ($extra_scanner->scan($self, $token, $token_type)) {
                last;
            }
        }
    }

    return $self->{modules};
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

