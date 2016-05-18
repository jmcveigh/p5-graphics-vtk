use Test::Most;
use File::Temp;
use File::Slurp qw(read_file);


BEGIN { 
	use_ok('Graphics::VTK'); 
	use_ok('Graphics::VTK::Util::Colors');
}


my $temp_png = File::Temp->new();

my $ren = vtk::vtkRenderer();
my $renWin = vtk::vtkRenderWindow();
$renWin->AddRenderer($ren);
my $WIDTH = 640;
my $HEIGHT = 480;
$renWin->SetSize($WIDTH,$HEIGHT);

# create a renderwindowinteractor
my $iren = vtk::vtkRenderWindowInteractor();
$iren->SetRenderWindow($renWin);

# create cone
my $cone = vtk::vtkConeSource();
$cone->SetResolution(60);
$cone->SetCenter(-2,0,0);

# mapper
my $coneMapper = vtk::vtkPolyDataMapper();
$coneMapper->SetInputConnection($cone->GetOutputPort());

# actor
my $coneActor = vtk::vtkActor();
$coneActor->SetMapper($coneMapper);

# assign actor to the renderer
$ren->AddActor($coneActor);

# enable user interface interactor
$iren->Initialize();
$renWin->Render();

my $winImgFilt = vtk::vtkWindowToImageFilter();
$winImgFilt->SetInput( $renWin );

my $pngWriter = vtk::vtkPNGWriter();
$pngWriter->SetInputConnection( $winImgFilt->GetOutputPort() );
$pngWriter->SetFileName( $temp_png->filename );

$winImgFilt->Modified();
$pngWriter->Write();

ok( -s $temp_png->filename, 'image file is not empty' );
my $contents = read_file($temp_png, bindmode => ':raw' );
ok( $contents =~ /^\x{89}PNG/, 'has PNG header' );

my $tomato;
ok($tomato = vtk::util::colors::tomato(), 'Color definitions ok');

done_testing;
