package Graphics::VTK::Backend::InlinePython;

use strict;
use warnings;

use feature qw(say switch);

use constant REGEX_CONSTANT => qr/^VTK_\w+$/;
use constant REGEX_CLASS => qr/^vtk\w+$/;
use constant REGEX_TYPE => qr/mutable|immutable/;
use Inline::Python qw(py_eval py_new_object py_call_method py_call_function);
use Inline Python => Graphics::VTK::PYTHON_VTK1;

Inline->init();

sub AUTOLOAD {
    my @components = split(/::/, our $AUTOLOAD);
	shift @components;
	
	my $result;
	my $call = join('.', @components);
	my $member = $components[-1];
	
	for($member) {
		when(REGEX_CONSTANT) {
			return(py_eval("vtk.${call}",0));
		}
		when(REGEX_CLASS) {			
			shift;
			my @arguments = @_;			
			my $arg_string = join(',',@arguments);
			(my $perl_class_suffix = $call) =~ s/\.([^\W])/::$1/;
			my $perl_class_name = "vtk::${perl_class_suffix}";
			$result = py_eval("proxy_vtk.${call}(${arg_string})",0) if (scalar(@arguments) > 0);
			$result = py_eval("proxy_vtk.${call}()",0) if (scalar(@arguments) == 0);
			bless $result, $perl_class_name;
			{
				no strict 'refs';
				push @{ "${perl_class_name}::ISA" }, 'Inline::Python::Object';
			};
			return($result);
		}
		when(REGEX_TYPE) {
			my @arguments = @_;	
			my $arg_string = join(',',@arguments);
			(my $perl_class_suffix = $call) =~ s/\.([^\W])/::$1/;
			my $perl_class_name = "vtk::${perl_class_suffix}";					
			$result = py_eval("proxy_vtk.${call}(${arg_string})",0) if (scalar(@arguments) > 0);
			$result = py_eval("proxy_vtk.${call}()",0) if (scalar(@arguments) == 0);
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
