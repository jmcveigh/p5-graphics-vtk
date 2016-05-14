#!/bin/perl

use strict;
use warnings;

use Graphics::VTK qw(:python);
 
my $filename = "example2_perl.ply";
 
my $sphereSource = vtk::vtkSphereSource();
$sphereSource->Update();
 
my $plyWriter = vtk::vtkPLYWriter();
$plyWriter->SetFileName($filename);
$plyWriter->SetInputConnection($sphereSource->GetOutputPort());
$plyWriter->Write();
 
#Read and display for verication
my $reader = vtk::vtkPLYReader();
$reader->SetFileName($filename);
$reader->Update();
 
my $mapper = vtk::vtkPolyDataMapper();
$mapper->SetInputConnection($reader->GetOutputPort());
 
my $actor = vtk::vtkActor();
$actor->SetMapper($mapper);
 
my $renderer = vtk::vtkRenderer();
my $renderWindow = vtk::vtkRenderWindow();
$renderWindow->AddRenderer($renderer);
my $renderWindowInteractor = vtk::vtkRenderWindowInteractor();
$renderWindowInteractor->SetRenderWindow($renderWindow);
 
$renderer->AddActor($actor);
$renderer->SetBackground(.3, .6, .3);   #Background color green
 
$renderWindow->Render();
$renderWindowInteractor->Start();
