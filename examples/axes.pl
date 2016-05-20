#!/bin/perl
use strict;
use warnings;

use Graphics::VTK;

my $sphereSource = vtk::vtkSphereSource();
$sphereSource->SetCenter(0.0, 0.0, 0.0);
$sphereSource->SetRadius(0.5);
 
my $sphereMapper = vtk::vtkPolyDataMapper();
$sphereMapper->SetInputConnection($sphereSource->GetOutputPort());

my $sphereActor = vtk::vtkActor();
$sphereActor->SetMapper($sphereMapper);

my $renderer = vtk::vtkRenderer();
my $renderWindow = vtk::vtkRenderWindow();
$renderWindow->AddRenderer($renderer);

my $renderWindowInteractor = vtk::vtkRenderWindowInteractor();
$renderWindowInteractor->SetRenderWindow($renderWindow);

$renderer->AddActor($sphereActor);
$renderer->SetBackground(0.1,0.2,0.3);
 
my $transform = vtk::vtkTransform();
$transform->Translate(1.0, 0.0, 0.0);
 
my $axes = vtk::vtkAxesActor();

$axes->SetUserTransform($transform);
  
$renderer->AddActor($axes);
 
$renderer->ResetCamera();
$renderWindow->Render();

$renderWindowInteractor->Start();
