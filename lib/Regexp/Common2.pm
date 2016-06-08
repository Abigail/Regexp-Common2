package Regexp::Common2;

use 5.20.0;
use strict;
use warnings;
no  warnings 'syntax';

use Scalar::Util 'reftype';

use feature  'signatures';
no  warnings 'experimental::signatures';

use Exporter ();

our @ISA       = qw [Exporter];
our @EXPORT_OK = qw [pattern RE];

our $VERSION   = '2016060801';

sub parse_keep;

my $CACHE = { };

#
# Indexes
#
my $PATTERN      = 0;
my $PATTERN_KEEP = 1;
my $CONFIG       = 2;
my $EXTRA_ARGS   = 3;


#
# Types
#
my $STRING     =  0;
my $REGEXP     =  1;
my $REF_SCALAR =  2;
my $REF_CODE   =  3;
my $REF_HASH   =  4;
my $REF_ARRAY  =  5;
my $REF_OTHER  =  6;

sub __ref ($thingy) {
    my $reftype = reftype $thingy;

    return $STRING     if !$reftype;
    return $REGEXP     if  $reftype eq "REGEXP";
    return $REF_CODE   if  $reftype eq "CODE";
    return $REF_HASH   if  $reftype eq "HASH";
    return $REF_ARRAY  if  $reftype eq "ARRAY";
    return $REF_SCALAR if  $reftype eq "SCALAR";

    return $REF_OTHER;
}

#
# Takes the following arguments:
#    + Name of pattern
#    + -pattern:      string, regexp or sub returning pattern (required)
#    + -pattern_keep: string, regexp or sub returning pattern (optional)
#    + -version:      minimal perl version required for pattern
#    + -config:       configuration parameters, and their default values
#    + -extra_args:   extra arguments passed to a pattern sub
#
sub pattern ($name, %args) {
    my $pattern = $args {-pattern} // die "A -pattern argument is required.\n";

    #
    # If a version is given. compare it with the current version of Perl.
    # Return if the current Perl is too old.
    #
    if (my $version = $args {-version}) {
        return if $version =~ /^5\.([0-9]+)$/ &&
                  $version > $];
    }

    my $cache;

    #
    # Check whether -pattern and -pattern_keep have valid types.
    #
    my $pat_ref = __ref $pattern;
    die "Value for -pattern must be string, regexp or coderef\n"
         unless $pat_ref   ==  $STRING   ||
                $pat_ref   ==  $REF_CODE ||
                $pat_ref   ==  $REGEXP;

    $$cache [$PATTERN] = $pattern;


    if (exists $args {-pattern_keep}) {
        my $pat_ref = $args {-pattern_keep};
        die "Value for -pattern_keep must be string, regexp or coderef\n"
             unless $pat_ref   ==  $STRING   ||
                    $pat_ref   ==  $REF_CODE ||
                    $pat_ref   ==  $REGEXP;
        $$cache [$PATTERN_KEEP] = $args {-pattern_keep};
    }
    else {
        $$cache [$PATTERN_KEEP] = $$cache [$PATTERN];
    }


    #
    # -config & -extra_args should be hashrefs; if not, store empty hashrefs.
    #
    $$cache [$CONFIG]     = $args {-config}      &&
                     __ref ($args {-config})     == $REF_HASH
                          ? $args {-config} : { };

    $$cache [$EXTRA_ARGS] = $args {-extra_args}  &&
                     __ref ($args {-extra_args}) == $REF_HASH
                          ? $args {-extra_args} : { };

    $$CACHE {$name} = $cache;
}



#
# Retrieve a pattern
#
sub RE ($name, %args) {
    my $cache = $$CACHE {$name} // die "No pattern named '$name' is known.\n";

    #
    # Grab the global parameters
    #
    my $keep             = delete $args {-Keep};
    my $anchor           = delete $args {-Anchor};
    my $case_insensitive = delete $args {-I};

    my $pattern = $$cache [$keep ? $PATTERN_KEEP : $PATTERN];

    my $ref = __ref $pattern;
    if ($ref == $REF_CODE) {
        $pattern = $pattern -> (%{$$cache [$CONFIG]},
                                %args,
                                %{$$cache [$EXTRA_ARGS]});
        $ref = __ref $pattern;

        die "Returned pattern for $name must be string on regexp\n"
             unless $ref == $STRING ||
                    $ref == $REGEXP;
    }

    $pattern = parse_keep $pattern, $keep if $ref == $STRING;

    # Deal with $anchor and $case_insenstive here

    return $pattern;
}


#
# Work needs to be done here!
#
sub parse_keep ($pattern, $keep) {
    $pattern =~ s {\(\?k (?: <([^>]+)> )? :}
                  {$keep ? defined $1 ? "(?<$1>" : "(" : "(?:"}xegr;
}

1;

__END__

=head1 NAME

Regexp::Common2 - Abstract

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 BUGS

=head1 TODO

=head1 SEE ALSO

=head1 DEVELOPMENT

The current sources of this module are found on github,
L<< git://github.com/Abigail/Regexp-Common2.git >>.

=head1 AUTHOR

Abigail, L<< mailto:cpan@abigail.be >>.

=head1 COPYRIGHT and LICENSE

Copyright (C) 2016 by Abigail.

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),   
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHOR BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 INSTALLATION

To install this module, run, after unpacking the tar-ball, the 
following commands:

   perl Makefile.PL
   make
   make test
   make install

=cut
