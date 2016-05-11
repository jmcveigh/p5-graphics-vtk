package Graphics::VTK::Util::Colors::Backend::InlinePython;

use strict;
use warnings;

use Inline Python => <<"END";
from vtk.util.colors import *

class vtkUtilColorsProxy(object):
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
      u_args_l = []; # final arguments
      for arg in args:
        # unwrap vtkProxy for calling
        arg = getattr( arg, '_target', arg )
        u_args_l.append( arg )
      u_args = tuple(u_args_l)

      # proxy the return value
      return vtkUtilColorsProxy(f(*u_args))

    return wrap_it

my_vtk_util_colors = vtkUtilColorsProxy(vtk.util.colors)
END

sub AUTOLOAD {
    (my $call = our $AUTOLOAD) =~ s/\w*::\w*::\w*:://;

    # check if syntax is correct
    die "error, this is not a python identifier: $call" unless( $call =~ /^[^\d\W]\w*\Z/ );

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    my $result = Inline::Python::py_eval("(float(${call}[0]),float(${call}[1]),float(${call}[2]))", 0);
	# memory arrangement
	my @r = (sprintf("%.4f", $result->[0]),sprintf("%.4f", $result->[1]),sprintf("%.4f", $result->[2]));
	return $result;
}

1;
