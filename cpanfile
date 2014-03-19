requires 'Class::Accessor::Lite';
requires 'Compiler::Lexer';
requires 'Module::Path';
requires 'perl', '5.008005';

on configure => sub {
    requires 'CPAN::Meta';
    requires 'CPAN::Meta::Prereqs';
    requires 'Module::Build';
};

on test => sub {
    requires 'Test::Deep';
    requires 'Test::More', '0.98';
};
