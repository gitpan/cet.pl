use Test::More tests => 1;

my $file = "blib/script/cet.pl";

print "bail out! Script file is missing!" unless -e $file;

my $output = `/usr/local/bin/perl -c $file 2>&1`;

print "bail out! Script file is missing!" unless
	like( $output, qr/syntax OK$/, 'script compiles' );
