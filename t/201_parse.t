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


{
    pattern "Test::parse::3",
            -pattern => "(?k<bar>:foo)(?k:baz)",
    ;


    my $pat1 = RE "Test::parse::3";
    my $pat2 = RE "Test::parse::3", -Keep => 1;

    is $pat1, '(?:foo)(?:baz)',   "Parsed (?k<bar>:)(?k:) to (?:)(?:)";
    is $pat2, '(?<bar>foo)(baz)', "Parsed (?k<bar>:)(?k:) to (?<bar>)()";
}


{
    pattern "Test::parse::4",
            -pattern => "(?k<bar>:(?k:foo))(?k:(?k<qux>:baz))",
    ;


    my $pat1 = RE "Test::parse::4";
    my $pat2 = RE "Test::parse::4", -Keep => 1;

    is $pat1, '(?:(?:foo))(?:(?:baz))',     "Parsed nested captures";
    is $pat2, '(?<bar>(foo))((?<qux>baz))', "Parsed nested captures";
}



Test::NoWarnings::had_no_warnings () if $r;

done_testing;
