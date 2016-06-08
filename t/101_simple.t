#!/usr/bin/perl

use 5.010;

use strict;
use warnings;
no  warnings 'syntax';

use Regexp::Common2 qw [pattern RE];

use Test::More 0.88;

our $r = eval "require Test::NoWarnings; 1";

pattern "Test::1",
        -pattern => 'foo';


my $pat = RE "Test::1";

is $pat, 'foo', "Set and retrieved pattern";


Test::NoWarnings::had_no_warnings () if $r;

done_testing;
