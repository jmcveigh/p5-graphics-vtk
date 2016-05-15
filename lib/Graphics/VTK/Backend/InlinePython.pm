package Graphics::VTK::Backend::InlinePython;

use strict;
use warnings;

use feature 'switch';

use constant TYPE_UNDEF => 0;
use constant TYPE_CONSTANT => 1;
use constant TYPE_MEMBER => 2;
use constant PREFIX_CONSTANT => 'VTK_';
use constant PREFIX_CLASS => 'vtk';

use Inline Python => Graphics::VTK::PYTHON_VTK1;

# py_call_function <package><function><args>
sub AUTOLOAD {
    my @components = split(/::/, our $AUTOLOAD);
	shift @components;
	
	my @arguments = @_;
	
	my $result;
	my $call = join('.', @components);
	my $member = $components[-1];
	
	(my $type = Inline::Python::py_eval("type(proxy_vtk.${call})", 0)) =~ s/\<type '(\w+)'\>/$1/;
	
	given($type) {
		when(/^function/) {
			given($member) {
				when(/^vtk\w+$/) {
					my $arg_string = join(',',@arguments);
					$result = Inline::Python::py_eval("proxy_vtk.${call}()",0);
					(my $perl_class_suffix = $result->GetClassName) =~ s/\.([^\d])/::$1/;
					my $perl_class_name = "vtk::${perl_class_suffix}";
					{
						no strict 'refs';
						push @{"${perl_class_name}"}, 'Inline::Python::Object';
					}
				}
			}
		}
	}
		
	return $result;
}

1;
