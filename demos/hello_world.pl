#!/bin/perl

use strict;
use warnings;

use Graphics::VTK qw(:python);
use Graphics::VTK::Util qw(:python);
use Graphics::VTK::Util::Colors qw(:python);
use Data::Dumper;

my $tomato = vtk::util::colors::tomato();

my $cylinder = vtk::vtkCylinderSource();
$cylinder->SetResolution(8);
 
# The mapper is responsible for pushing the geometry into the graphics
# library. It may also do color mapping, if scalars or other
# attributes are defined.
my $cylinderMapper = vtk::vtkPolyDataMapper();
$cylinderMapper->SetInputConnection($cylinder->GetOutputPort());

# The actor is a grouping mechanism: besides the geometry (mapper), it
# also has a property, transformation matrix, and/or texture map.
# Here we set its color and rotate it -22.5 degrees.
my $cylinderActor = vtk::vtkActor();
$cylinderActor->SetMapper($cylinderMapper);
$cylinderActor->GetProperty()->SetColor($tomato);
$cylinderActor->RotateX(30.0);
$cylinderActor->RotateY(-45.0);
 
# Create the graphics structure. The renderer renders into the render
# window. The render window interactor captures mouse events and will
# perform appropriate camera or actor manipulation depending on the
# nature of the events.
my $ren = vtk::vtkRenderer();
my $renWin = vtk::vtkRenderWindow();
$renWin->AddRenderer($ren);
my $iren = vtk::vtkRenderWindowInteractor();
$iren->SetRenderWindow($renWin);
 
# Add the actors to the renderer, set the background and size
$ren->AddActor($cylinderActor);
$ren->SetBackground(0.1, 0.2, 0.4);
$renWin->SetSize(200, 200);
 
# This allows the interactor to initalize itself. It has to be
# called before an event loop.
$iren->Initialize();
 
# We'll zoom in a little by accessing the camera and invoking a "Zoom"
# method on it.
$ren->ResetCamera();
$ren->GetActiveCamera()->Zoom(1.5);
$renWin->Render();
 
# Start the event loop.
$iren->Start();
