# $Id: Build.PL,v 1.6 2008/02/08 08:01:14 asc Exp $

use strict;
use Module::Build;

my $build = Module::Build->new(module_name => 'Net::Flickr::API',
			       # dist_author
			       # dist_abstract
			       dist_version_from => 'lib/Net/Flickr/API.pm',
			       license           => 'perl',
			       requires => {
				   'Config::Simple'  => '0',
				   'Flickr::API'     => '>= 0.09',
				   'Readonly'        => '0',
				   'Log::Dispatch'   => '>= 2.10',
				   'XML::XPath'      => '>= 1.13',
			       },
			       build_requires => {
				   'Test::Simple'              => '>= 0.47',
			       },
			       create_readme      => 1,
			       create_makefile_pl => 'passthrough');

$build->create_build_script();
