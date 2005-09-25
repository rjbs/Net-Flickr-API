# $Id: Build.PL,v 1.2 2005/09/25 14:29:59 asc Exp $

use strict;
use Module::Build;

my $build = Module::Build->new(module_name => 'Net::Flickr::API',
			       # dist_author
			       # dist_abstract
			       dist_version_from => 'lib/Net/Flickr/API.pm',
			       license           => 'perl',
			       requires => {
				   'Config::Simple'  => '0',
				   'Flickr::API'     => '>= 0.07',
				   'Readonly'        => '0',
				   'Log::Dispatch'   => '>= 2.10',
				   # Tries to use XML::LibXML first
				   'XML::XPath'      => '>= 1.13',
			       },
			       build_requires => {
				   'Test::Simple'              => '>= 0.47',
			       },
			       create_readme      => 1,
			       create_makefile_pl => 'passthrough');

$build->create_build_script();
