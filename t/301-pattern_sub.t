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
            -pattern => sub {
                "(?k:foo)"
            },
    ;


    my $pat1 = RE "Test::parse::1";
    my $pat2 = RE "Test::parse::1", -Keep => 1;

    is $pat1, '(?:foo)', "Use of sub returning a constant";
    is $pat2, '(foo)',   "Use of sub returning a constant, under -Keep";
}



{
    pattern "Test::parse::2",
            -config  => {
                -one   => "Hello",
            },
            -pattern => sub {
                my %args = @_;
                "<" . ($args {-one} // "UNDEF") . ">";
            },
    ;


    my $pat1 = RE "Test::parse::2";
    my $pat2 = RE "Test::parse::2", -Keep => 1;

    is $pat1, '<Hello>', "One config parameter; using default";
    is $pat2, '<Hello>', "One config parameter; using default, under -Keep";

    my $pat3 = RE "Test::parse::2", -one => "world";
    my $pat4 = RE "Test::parse::2", -one => "world", -Keep => 1;

    is $pat3, '<world>', "One config parameter; set value";
    is $pat4, '<world>', "One config parameter; set value, under -Keep";
}


{
    pattern "Test::parse::3",
            -config  => {
                -two   =>  undef,
            },
            -pattern => sub {
                my %args = @_;
                "<<" . ($args {-two} // "UNDEF") . ">>";
            },
    ;


    my $pat1 = RE "Test::parse::3";
    my $pat2 = RE "Test::parse::3", -Keep => 1;

    is $pat1, '<<UNDEF>>', "One config parameter (undef); using default";
    is $pat2, '<<UNDEF>>', "One config parameter (undef); using default, " .
                           "under -Keep";

    my $pat3 = RE "Test::parse::3", -two => "bubba";
    my $pat4 = RE "Test::parse::3", -two => "bubba", -Keep => 1;

    is $pat3, '<<bubba>>', "One config parameter (undef); set value";
    is $pat4, '<<bubba>>', "One config parameter (undef); set value, " .
                           "under -Keep";
}


{
    pattern "Test::parse::4",
            -config  => {
                -three   =>  undef,
                -four    => 'fnord',
            },
            -pattern => sub {
                my %args = @_;
                my $three = $args {-three} // "UNDEF";
                my $four  = $args {-four}  // "UNDEF";
                "<<<$three|$four>>>";
            },
    ;


    my $pat1 = RE "Test::parse::4";
    my $pat2 = RE "Test::parse::4", -Keep => 1;

    is $pat1, '<<<UNDEF|fnord>>>', "Multiple config parameters; using defaults";
    is $pat2, '<<<UNDEF|fnord>>>', "Multiple config parameters; " .
                                   "using defaults, under -Keep";

    my $pat3 = RE "Test::parse::4", -three => "bubbles";
    my $pat4 = RE "Test::parse::4", -three => "bubbles", -Keep => 1;

    is $pat3, '<<<bubbles|fnord>>>', "Multiple config parameters; setting one";
    is $pat4, '<<<bubbles|fnord>>>', "Multiple config parameters; " .
                                     "setting one, under -Keep";

    my $pat5 = RE "Test::parse::4", -four => "quux";
    my $pat6 = RE "Test::parse::4", -four => "quux", -Keep => 1;

    is $pat5, '<<<UNDEF|quux>>>', "Multiple config parameters; setting other";
    is $pat6, '<<<UNDEF|quux>>>', "Multiple config parameters; " .
                                  "setting other, under -Keep";

    my $pat7 = RE "Test::parse::4", -three => "three", -four => "four";
    my $pat8 = RE "Test::parse::4", -three => "three", -four => "four",
                                    -Keep => 1;

    is $pat7, '<<<three|four>>>', "Multiple config parameters; setting both";
    is $pat8, '<<<three|four>>>', "Multiple config parameters; " .
                                  "setting both, under -Keep";

}



Test::NoWarnings::had_no_warnings () if $r;

done_testing;
