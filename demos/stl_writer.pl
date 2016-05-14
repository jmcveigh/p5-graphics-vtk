#!/bin/perl

use strict;
use warnings;

use Graphics::VTK qw(:python);

my $filename = "test.stl";
 
my $sphereSource = vtk::vtkSphereSource();
$sphereSource->Update();
 
# Write the stl file to disk
my $stlWriter = vtk::vtkSTLWriter();
$stlWriter->SetFileName($filename);
$stlWriter->SetInputConnection($sphereSource->GetOutputPort());
$stlWriter->Write();
 
# Read and display for verification
my $reader = vtk::vtkSTLReader();
$reader->SetFileName($filename);
 
my $mapper = vtk::vtkPolyDataMapper();
$mapper->SetInputConnection($reader->GetOutputPort());
 
my $actor = vtk::vtkActor();
$actor->SetMapper($mapper);
 
# Create a rendering window and renderer
my $ren = vtk::vtkRenderer();
my $renWin = vtk::vtkRenderWindow();
$renWin->AddRenderer($ren);
 
# Create a renderwindowinteractor
my $iren = vtk::vtkRenderWindowInteractor();
$iren->SetRenderWindow($renWin);
 
# Assign actor to the renderer
$ren->AddActor($actor);
 
# Enable user interface interactor
$iren->Initialize();
$renWin->Render();
$iren->Start();
