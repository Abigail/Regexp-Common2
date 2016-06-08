#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Regexp::Common2 qw [pattern RE];

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

{
    pattern "Test::1",
            -pattern => 'foo';


    my $pat = RE "Test::1";

    is $pat, 'foo', "Set and retrieved string pattern";
}


{
    pattern "Test::2",
            -pattern => qr /foo/;


    my $pat = RE "Test::2";

    is $pat, '(?^:foo)', "Set and retrieved regex pattern";
}


{
    pattern "Test::3",
            -pattern => sub {"foo"};


    my $pat = RE "Test::3";

    is $pat, 'foo', "Set and retrieved pattern via code ref";
}


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
