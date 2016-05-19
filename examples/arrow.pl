#!/bin/perl

use strict;
use warnings;

use Graphics::VTK;
 
my $arrowSource = vtk::vtkArrowSource();
 
my $mapper = vtk::vtkPolyDataMapper();
$mapper->SetInputConnection($arrowSource->GetOutputPort());
my $actor = vtk->vtkActor();
$actor->SetMapper($mapper);
 
my $renderer = vtk::vtkRenderer();
my $renderWindow = vtk::vtkRenderWindow();
$renderWindow->AddRenderer($renderer);
my $renderWindowInteractor = vtk::vtkRenderWindowInteractor();
$renderWindowInteractor->SetRenderWindow($renderWindow);
 
$renderer->AddActor($actor);
$renderer->SetBackground(0.1, 0.2, 0.3);
 
$renderWindow->Render();
$renderWindowInteractor->Start();
