package Text::WordGrams;

use warnings;
use strict;

require Exporter;

use Lingua::PT::PLNbase;

=head1 NAME

Text::WordGrams - Calculates statistics on word ngrams.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
our @ISA = "Exporter";
our @EXPORT = "word_grams";

=head1 SYNOPSIS

    use Text::WordGrams;

    my $data = word_grams( $text );

=head1 FUNCTIONS

=head2 word_grams

Returns a reference to an hash table with word ngrams counts for a
specified string. Options are passed as a hash reference as first
argument if needed.

Options include:

=over 4

=item ignore_case

Set this option to ignore text case;

=item size

Set this option to the n-gram size you want. Notice that the value
should be greater or equal to two. Also, keep in mind that the bigger
size you ask for, the larger the hash will become. Future releases
might include a DB File version for less memory consuption.

=back

=cut

sub word_grams {
  my $conf = {};
  $conf = shift if (ref($_[0]) eq "HASH");
  $conf->{size} = 2 unless $conf->{size} && $conf->{size} > 1;

  my $text = shift;
  $text = lc($text) if $conf->{ignore_case};
  my @atoms = atomiza($text);
  my $data;

  my $previous = shift @atoms;
  my $next;
  while ($next = _get($conf->{size}-1, \@atoms)) {
    $data->{"$previous $next"}++;
    $previous = shift @atoms;
  }
  return $data
}

sub _get {
  my ($n, $atoms) = @_;
  if ($n <= $#$atoms + 1) {
    return join(" ", @{$atoms}[0..$n-1])
  } else {
    return undef
  }
}

=head1 AUTHOR

Alberto Simões, C<< <ambs@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-text-wordgrams@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-WordGrams>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2005 Alberto Simões, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Text::WordGrams
