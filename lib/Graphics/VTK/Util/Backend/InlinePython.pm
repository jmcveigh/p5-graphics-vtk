package Graphics::VTK::Util::Backend::InlinePython;

use strict;
use warnings;

use Inline Python => <<'END';
import vtk.util

class vtkUtilProxy(object):
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
      return vtkUtilProxy(f(*u_args))

    return wrap_it

my_vtk_util = vtkUtilProxy(vtk.util)
END

sub AUTOLOAD {
    (my $call = our $AUTOLOAD) =~ s/\w*::\w*::\w*:://;

    # check if syntax is correct
    die "error, this is not a python identifier: $call" unless( $call =~ /^[^\d\W]\w*\Z/ );

    my $result = Inline::Python::py_eval("my_vtk_util.$call()", 0);
    if( my $class = eval { $result->GetClassName() } ){
        my $new_vtk_class = "vtk::util::$class";
        bless $result, $new_vtk_class;
        {
            no strict 'refs';
            push @{ "${new_vtk_class}::ISA" }, 'Inline::Python::Object';
        }
    }

    return $result;
}

1;
