package Graphics::VTK::Util::Backend::InlinePython;

use strict;
use warnings;

use Graphics::VTK qw(:python);
use Inline Python => Graphics::VTK::PYTHON_VTK1;

sub AUTOLOAD {
    (my $call = our $AUTOLOAD) =~ s/\w*::\w*:://;

    # check if syntax is correct
    die "error, this is not a python identifier: $call" unless( $call =~ /^[^\d\W]\w*\Z/ );

	my $parenthesis = ($call =~ /(vtkVariant)/) ? "" : "()" ;
	
    my $result = Inline::Python::py_eval("proxy_vtk_util.$call$parenthesis", 0);
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
