#!/usr/bin/perl
use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Regexp::Common2 qw [pattern RE];

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";


sub make_pattern {
    my %args = @_;
    my $thingy = $args {-key} // "UNDEF";
    "Match $thingy";
}

{
    pattern "Test::parse::1",
            -extra_args => {
                -foo        =>  "bar",
            },
            -pattern    => sub {
                my %args = @_;
                my $foo  = $args {-foo} // "UNDEF";
                $foo;
            },
    ;


    my $pat = RE "Test::parse::1";

    is $pat, 'bar', "Use of sub with -extra_args";
}


{
    pattern "Test::parse::2",
            -extra_args => {
                -baz        =>  "qux",
            },
            -pattern    => sub {
                my %args = @_;
                my $baz  = $args {-baz} // "UNDEF";
                qr /$baz/;
            },
    ;


    my $pat = RE "Test::parse::2";

    is $pat, '(?^:qux)', "Use of sub returning qr // with -extra_args";
}



{
    pattern "Test::parse::3",
            -extra_args => {
                -key        =>  "key3",
            },
            -pattern    => \&make_pattern,
    ;

    pattern "Test::parse::4",
            -extra_args => {
                -key        =>  "key4",
            },
            -pattern    => \&make_pattern,
    ;

    my $pat3 = RE "Test::parse::3";
    my $pat4 = RE "Test::parse::4";

    is $pat3, 'Match key3', "Shared sub with -extra_args, part 1";
    is $pat4, 'Match key4', "Shared sub with -extra_args, part 2";
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
