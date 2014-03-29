package Perl::PrereqScanner::Lite::Constants;
use strict;
use warnings;
use utf8;
use Compiler::Lexer::Constants;

use parent qw(Exporter);

our @EXPORT = qw(
    REQUIRE_DECL REQUIRED_NAME NAMESPACE_RESOLVER NAMESPACE
    SEMI_COLON USE_DECL USED_NAME REG_LIST REG_EXP LEFT_PAREN
    RIGHT_PAREN STRING RAW_STRING VERSION_STRING INT DOUBLE KEY
    METHOD WHITESPACE COMMENT
);

use constant {
    REQUIRE_DECL       => Compiler::Lexer::TokenType::T_RequireDecl,
    REQUIRED_NAME      => Compiler::Lexer::TokenType::T_RequiredName,
    NAMESPACE_RESOLVER => Compiler::Lexer::TokenType::T_NamespaceResolver,
    NAMESPACE          => Compiler::Lexer::TokenType::T_Namespace,
    SEMI_COLON         => Compiler::Lexer::TokenType::T_SemiColon,
    USE_DECL           => Compiler::Lexer::TokenType::T_UseDecl,
    USED_NAME          => Compiler::Lexer::TokenType::T_UsedName,
    REG_LIST           => Compiler::Lexer::TokenType::T_RegList,
    REG_EXP            => Compiler::Lexer::TokenType::T_RegExp,
    LEFT_PAREN         => Compiler::Lexer::TokenType::T_LeftParenthesis,
    RIGHT_PAREN        => Compiler::Lexer::TokenType::T_RightParenthesis,
    STRING             => Compiler::Lexer::TokenType::T_String,
    RAW_STRING         => Compiler::Lexer::TokenType::T_RawString,
    VERSION_STRING     => Compiler::Lexer::TokenType::T_VersionString,
    INT                => Compiler::Lexer::TokenType::T_Int,
    DOUBLE             => Compiler::Lexer::TokenType::T_Double,
    KEY                => Compiler::Lexer::TokenType::T_Key,
    METHOD             => Compiler::Lexer::TokenType::T_Method,
    WHITESPACE         => Compiler::Lexer::TokenType::T_WhiteSpace,
    COMMENT            => Compiler::Lexer::TokenType::T_Comment,
};

1;

