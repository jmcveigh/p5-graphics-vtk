package Graphics::VTK;

use strict;
use warnings;

use constant PYTHON_VTK1 => <<'END';
import vtk;
import vtk.util;
from vtk.util.colors import *

class vtkProxy(object):
  def __init__(self, target):
    self._target = target
    self._majorVersion = vtk.vtkVersion().GetVTKMajorVersion()

  def __str__(self):
    return str(self._target)

  def __repr__(self):
    return repr(self._target)

  def __getattr__(self, aname):
    target = self._target
    f = getattr(target, aname)

    def wrap_it(*args):
      u_args_l = [];
      for arg in args:
        arg = getattr( arg, '_target', arg )
        u_args_l.append( arg )
      u_args = tuple(u_args_l)

      return vtkProxy(f(*u_args))

    return wrap_it

proxy_vtk = vtkProxy(vtk)
proxy_vtk_util = vtkProxy(vtk.util)

END

sub import {
	my ($self, $opt) = @_;
	if( $opt eq ':python' ) {
		eval {
			require Graphics::VTK::Backend::InlinePython;
			*vtk::AUTOLOAD = \&Graphics::VTK::Backend::InlinePython::AUTOLOAD;
			1;
		} or do {
			my $error = $@;
			die "Could not load Inline::Python: $error";
		}
	}
}

1;
