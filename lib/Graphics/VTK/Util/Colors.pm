package Graphics::VTK::Util::Colors;

use strict;
use warnings;

sub import {
	my ($self, $opt) = @_;
	if( $opt eq ':python' ) {
		eval {
			require Graphics::VTK::Util::Colors::Backend::InlinePython;
			*vtk::util::colors::AUTOLOAD = \&Graphics::VTK::Util::Colors::Backend::InlinePython::AUTOLOAD;
			1;
		} or do {
			my $error = $@;
			die "error, could not load inline python: $error";
		}
	}
}

1;
