#!/usr/bin/perl

use strict;
use warnings;
use Term::ANSIColor;

my @rules = @ARGV;
while (my $line = <STDIN>) {
  print rewrite($line, @rules);
}
exit;

# Process a single line
sub rewrite {
  my $line = shift;
  my @rules = @_;
  my @marks = ();
  # Process each rule and find areas to mark
  while (@rules) {
    my $regex = shift @rules;
    my $color = shift @rules || 'bold yellow';
    $color = color('reset').color($color);
    while ($line =~ /$regex/ig) {
      my $reset = undef;
      # Scan match area to find last color
      foreach my $i (reverse $-[0] .. $+[0]) {
        if (defined $marks[$i]) {
          $reset = $marks[$i] unless defined $reset;
          $marks[$i] = undef; # Cancel previous color
        }
      }
      # If necessary, keep scanning to beginning of line
      unless (defined $reset) {
        foreach my $i (reverse 0 .. $-[0]) {
          if (defined $marks[$i]) {
            $reset = $marks[$i];
            last;
          }
        }
      }
      # Mark area
      $marks[$-[0]] = $color;
      $marks[$+[0]] = $reset || color('reset');
    }
  }
  # Apply color codes to the string
  foreach my $i (reverse 0 .. $#marks) {
    substr($line, $i, 0, $marks[$i]) if defined $marks[$i];
  }
  return $line;
}

=pod

=head1 NAME

cet - console emphasis tool

=head1 VERSION

Version 2.00

=cut

our $VERSION = '2.00';

=head1 DESCRIPTION

cet.pl is a command line tool for visually emphasizing text in log files
etc. by colorizing the output matching regular expressions.

=head1 SYNOPSIS

cet.pl REGEX1 [COLOR1] [REGEX2 [COLOR2]] ... [REGEXn [COLORn]]

=head1 USAGE

REGEX is any regular expression recognized by Perl. For some shells
this must be enclosed in double quotes ("") to prevent the shell from
interpolating special characters like * or ?.

COLOR is any ANSI color string accepted by Term::ANSIColor, such as
'green' or 'bold red'.

Any number of REGEX-COLOR pairs may be specified. If the number of
arguments is odd (i.e. no COLOR is specified for the last REGEX) cet.pl
will use 'bold yellow'.

Overlapping rules are supported. For characters that match multiple rules,
only the last rule will be applied.

=head1 EXAMPLES

In a system log, emphasize the words "error" and "ok":

=over

tail -f /var/log/messages | cet.pl error red ok green

=back

In a mail server log, show all email addresses between <> in white,
successes in green:

=over

tail -f /var/log/maillog | cet.pl "(?<=\<)[\w\-\.]+?\@[\w\-\.]+?(?=\>)" "bold white" "stored message|delivered ok" "bold green"

=back

In a web server log, show all URIs in yellow:

=over

tail -f /var/log/httpd/access_log | cet.pl "(?<=\"get).+?\s"

=back

=head1 BUGS AND LIMITATIONS

Multi-line matching is not implemented.

All regular expressions are matched without case sensitivity.

=head1 AUTHOR

Andreas Lund C<floyd at atc.no>

=head1 MODULE MAINTAINER

C Hutchinson C<taint at cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2009-2013 Andreas Lund C<floyd at atc.no>. This program is free software;
you may redistribute it and/or modify it under the same terms as Perl itself.

=cut
