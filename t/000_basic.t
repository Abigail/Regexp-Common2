#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

BEGIN {
    use_ok ('Regexp::Common2') or
        BAIL_OUT ("Loading of 'Regexp::Common2' failed");
}

ok defined $Regexp::Common2::VERSION, "VERSION is set";

Test::NoWarnings::had_no_warnings () if $r;

done_testing;
