package Regexp::Common2;

use 5.20.0;
use strict;
use warnings;
no  warnings 'syntax';

use feature  'signatures';
no  warnings 'experimental::signatures';

use Exporter ();

our @ISA       = qw [Exporter];
our @EXPORT_OK = qw [pattern RE];

our $VERSION   = '2016060801';

my $CACHE = { };

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

    my $cache;

    unless (!ref ($pattern)            ||
             ref ($pattern) eq "CODE"  ||
             ref ($pattern) eq "Regexp") {
        die "Value for -pattern must be string, regexp or coderef\n";
    }

    $$cache {pattern} = $pattern;


    if (exists $args {-pattern_keep}) {
        my $pattern_keep = $args {-pattern_keep};
        unless (!ref ($pattern)            ||
                 ref ($pattern) eq "CODE"  ||
                 ref ($pattern) eq "Regexp") {
            die "Value for -pattern_keep must be string, regexp or coderef\n";
        }
        $$cache {pattern_keep} = $pattern_keep;
    }
    else {
        $$cache {pattern_keep} = $$cache {pattern};
    }

    #
    # If a version is given. compare it with the current version of Perl.
    # Return if the current Perl is too old.
    #
    if (my $version = $args {-version}) {
        return if $version =~ /^5\.([0-9]+)$/ &&
                  $version > $];
    }
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
