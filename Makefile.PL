use ExtUtils::MakeMaker 6.48;

eval "use Test::Manifest 1.21";

my $script_name = "cet.pl";

WriteMakefile(
	'NAME'       => $script_name,
	'AUTHOR'     => q{Andreas Lund <floyd@atc.no>},
	'VERSION'    => '2.00',
	'EXE_FILES'  =>  [ $script_name ],
	'LICENSE'    => 'Artistic_1_0',
	'PREREQ_PM'  => {
	},
	MIN_PERL_VERSION => 5,
	dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	clean => { FILES => "*.bak $script_name-*" },
	);

1;
