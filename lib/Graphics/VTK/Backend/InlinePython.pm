package Graphics::VTK::Backend::InlinePython;

use strict;
use warnings;

use Inline Python => Graphics::VTK::PYTHON_VTK1;

sub AUTOLOAD {
    (my $call = our $AUTOLOAD) =~ s/\w*:://;

    die "error, this is not a python identifier: $call" unless( $call =~ /^[^\d\W]\w*\Z/ );

    my $result = Inline::Python::py_eval("proxy_vtk.$call()", 0);
    if( my $class = eval { $result->GetClassName() } ){
        my $new_vtk_class = "vtk::$class";
        bless $result, $new_vtk_class;
        {
            no strict 'refs';
            push @{ "${new_vtk_class}::ISA" }, 'Inline::Python::Object';
        }
    }

    return $result;
}

1;
