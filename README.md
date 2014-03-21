[![Build Status](https://travis-ci.org/moznion/Perl-PrereqScanner-Lite.png?branch=master)](https://travis-ci.org/moznion/Perl-PrereqScanner-Lite)
# NAME

Perl::PrereqScanner::Lite - Lightweight Prereqs Scanner for Perl

# SYNOPSIS

    use Perl::PrereqScanner::Lite;

    my $scanner = Perl::PrereqScanner::Lite->new;
    $scanner->add_extra_scanner('Moose');
    my $modules = $scanner->scan_file('path/to/file');

# DESCRIPTION

Perl::PrereqScanner::Lite is the lightweight prereqs scanner for perl.
This scanner uses [Compiler::Lexer](https://metacpan.org/pod/Compiler::Lexer) as tokenizer, therefore processing speed is really fast.

# METHODS

- new

    Create scanner instance.

- scan\_file($file\_path)

    Scan and figure out prereqs which is instance of `CPAN::Meta::Requirements` by file path.

- scan\_string($string)

    Scan and figure out prereqs which is instance of `CPAN::Meta::Requirements` by source code string written in perl.

    e.g.

        open my $fh, '<', __FILE__;
        my $string = do { local $/; <$fh> };
        my $modules = $scanner->scan_string($string);

- scan\_module($module\_name)

    Scan and figure out prereqs which is instance of `CPAN::Meta::Requirements` by module name.

    e.g.

        my $modules = $scanner->scan_module('Perl::PrereqScanner::Lite');

- scan\_tokens($tokens)

    Scan and figure out prereqs which is instance of `CPAN::Meta::Requirements` by tokens of [Compiler::Lexer](https://metacpan.org/pod/Compiler::Lexer).

    e.g.

        open my $fh, '<', __FILE__;
        my $string = do { local $/; <$fh> };
        my $tokens = Compiler::Lexer->new->tokenize($string);
        my $modules = $scanner->scan_tokens($tokens);

- add\_extra\_scanner($scanner\_name)

    Add extra scanner to scan and figure out prereqs. This module loads extra scanner such as `Perl::PrereqScanner::Lite::Scanner::$scanner_name` if specifying scanner name through this method.

    Now this module supports extra scanner for [Moose](https://metacpan.org/pod/Moose) families `extends` notation.
    Please see also [Perl::PrereqScanner::Lite::Scanner::Moose](https://metacpan.org/pod/Perl::PrereqScanner::Lite::Scanner::Moose).

# SEE ALSO

[Perl::PrereqScanner](https://metacpan.org/pod/Perl::PrereqScanner), [Compiler::Lexer](https://metacpan.org/pod/Compiler::Lexer)

# LICENSE

Copyright (C) moznion.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

moznion <moznion@gmail.com>
