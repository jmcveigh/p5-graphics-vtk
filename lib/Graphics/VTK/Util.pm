package Graphics::VTK::Util;

use strict;
use warnings;

sub import {
	my ($self, $opt) = @_;
	if( $opt eq ':python' ) {
		eval {
			require Graphics::VTK::Backend::InlinePython;
			*vtk::util::AUTOLOAD = \&Graphics::VTK::Util::Backend::InlinePython::AUTOLOAD;
			1;
		} or do {
			my $error = $@;
			die "error, could not load inline python: $error";
		}
	}
}

1;
