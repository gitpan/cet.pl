use ExtUtils::MakeMaker 6.48;

eval "use Test::Manifest 1.21";

my $script_name = "cet.pl";

WriteMakefile(
	'NAME'       => $script_name,
	'ABSTRACT'   => 'console emphasis tool',
	'VERSION'    => '2.01',
	'LICENSE'    => 'artistic',
	'AUTHOR'     => q{Andreas Lund <floyd@atc.no>, maintained by C Hutchinson <taint@cpan.org>},
	'EXE_FILES'  =>  [ $script_name ],
	'PREREQ_PM'  => {
		'Test::More' => '0.95',
	},
	'META_MERGE' => {
		no_index => {
			dir       => [ qw( t ) ],
			directory => [ qw( t ) ],
			},
	},
	MIN_PERL_VERSION => '5.8.9',
	dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	clean => { FILES => "*.bak $script_name-*" },
	);

1;
