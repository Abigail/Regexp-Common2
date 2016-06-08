#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Regexp::Common2 qw [pattern RE];

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";


{
    pattern "Test::parse::1",
            -pattern => "(?k:foo)",
    ;


    my $pat1 = RE "Test::parse::1";
    my $pat2 = RE "Test::parse::1", -Keep => 1;

    is $pat1, '(?:foo)', "Parsed (?k:) to (?:)";
    is $pat2, '(foo)',   "Parsed (?k:) to ()";
}


{
    pattern "Test::parse::2",
            -pattern => "(?k<bar>:foo)",
    ;


    my $pat1 = RE "Test::parse::2";
    my $pat2 = RE "Test::parse::2", -Keep => 1;

    is $pat1, '(?:foo)',     "Parsed (?k<bar>:) to (?:)";
    is $pat2, '(?<bar>foo)', "Parsed (?k<bar>:) to (?<bar>)";
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
