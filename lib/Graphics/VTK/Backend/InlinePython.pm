package Graphics::VTK::Backend::InlinePython;

use strict;
use warnings;

use feature 'switch';

use constant TYPE_UNDEF => 0;
use constant TYPE_CONSTANT => 1;
use constant TYPE_MEMBER => 2;
use constant PREFIX_CONSTANT => 'VTK_';
use constant PREFIX_CLASS => 'vtk';

use Inline::Python qw(py_eval py_new_object py_call_method py_call_function);
use Inline Python => Graphics::VTK::PYTHON_VTK1;

Inline->init();

sub AUTOLOAD {
    my @components = split(/::/, our $AUTOLOAD);
	shift @components;
	
	my @arguments = @_;
	
	my $result;
	my $call = join('.', @components);
	my $member = $components[-1];
	
	given($member) {
		when(/^VTK_\w+$/) {
			return(py_eval("vtk.${call}",0));
		}
		when(/^vtk\w+$/) {
			my $arg_string = join(',',@arguments);
			(my $perl_class_suffix = $call) =~ s/\.([^\d])/::$1/;
			my $perl_class_name = "vtk::${perl_class_suffix}";					
			$result = py_eval("proxy_vtk.${call}()",0);
			bless $result, $perl_class_name;
			{
				no strict 'refs';
				push @{ "${perl_class_name}::ISA" }, 'Inline::Python::Object';
			};
			return($result);
		}
	}
}

1;
