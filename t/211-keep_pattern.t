#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Regexp::Common2 qw [pattern RE];

use Test::More 0.88;
use Test::Exception;

our $r = eval "require Test::NoWarnings; 1";

#
# Test whether -pattern_keep returns a different thing.
#
{
    pattern "This::is::a::test" =>
            -pattern       =>  'foo',
            -pattern_keep  =>  'bar',
    ;

    my $pat  = RE "This::is::a::test";
    my $patk = RE "This::is::a::test", -Keep => 1;

    is $pat,  'foo', "-pattern returned as string";
    is $patk, 'bar', "-pattern_keep returned as string";
}

#
# Test whether -pattern_keep returns a different thing; now using regexes
#
{
    pattern "This::is::a::test2" =>
            -pattern       =>  qr /foo/,
            -pattern_keep  =>  qr /bar/,
    ;

    my $pat  = RE "This::is::a::test2";
    my $patk = RE "This::is::a::test2", -Keep => 1;

    is $pat,  '(?^:foo)', "-pattern returned as regexp";
    is $patk, '(?^:bar)', "-pattern_keep returned as regexp";
}



#
# Test whether -pattern_keep returns a different thing; parsing of (?k:)
# should still happen though.
#
{
    pattern "This::is::a::test3" =>
            -pattern       =>  '(?k:foo)',
            -pattern_keep  =>  '(?k:bar)',
    ;

    my $pat  = RE "This::is::a::test3";
    my $patk = RE "This::is::a::test3", -Keep => 1;

    is $pat,  '(?:foo)', "-pattern returned as string (parsed)";
    is $patk, '(bar)',   "-pattern_keep returned as string (parsed)";
}



#
# Cannot have a only -pattern_keep -- must have a -pattern
#
{
    throws_ok {
        pattern "This::is::a::test4" =>
                -pattern_keep  =>  '(?k:bar)',
        ;
    } qr /A -pattern argument is required/,
      "-pattern is required";
}




Test::NoWarnings::had_no_warnings () if $r;

done_testing;
