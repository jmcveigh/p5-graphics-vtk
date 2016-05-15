package Graphics::VTK::Util::Colors;

use strict;
use warnings;

sub import {
	my ($self, $opt) = @_;
	require Graphics::VTK::Util::Colors::Backend::InlinePython;
	*vtk::util::colors::AUTOLOAD = \&Graphics::VTK::Util::Colors::Backend::InlinePython::AUTOLOAD;
	1;
}

1;
