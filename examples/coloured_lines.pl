#!/bin/perl

use strict;
use warnings;

use Graphics::VTK;

my $origin = [0.0, 0.0, 0.0];
my $p0 = [1.0, 0.0, 0.0];
my $p1 = [0.0, 1.0, 0.0];
 
my $pts = vtk::vtkPoints();
$pts->InsertNextPoint($origin);
$pts->InsertNextPoint($p0);
$pts->InsertNextPoint($p1);
 
my $red = [255, 0, 0];
my $green = [0, 255, 0];
 
my $colours = vtk::vtkUnsignedCharArray();
$colours->SetNumberOfComponents(3);
$colours->SetName("Colours");
 
# Add the colours we created to the colors array
$colours->InsertNextTupleValue($red);
$colours->InsertNextTupleValue($green);
 
my $line0 = vtk::vtkLine();
$line0->GetPointIds()->SetId(0,0); # the second 0 is the index of the Origin in the vtkPoints
$line0->GetPointIds()->SetId(1,1); # the second 1 is the index of P0 in the vtkPoints
 
# Create the second line (between Origin and P1)
my $line1 = vtk::vtkLine();
$line1->GetPointIds()->SetId(0,0); # the second 0 is the index of the Origin in the vtkPoints
$line1->GetPointIds()->SetId(1,2); # 2 is the index of P1 in the vtkPoints
 
# Create a cell array to store the lines in and add the lines to it
my $lines = vtk::vtkCellArray();
$lines->InsertNextCell($line0);
$lines->InsertNextCell($line1);
 
# Create a polydata to store everything in
my $linesPolyData = vtk::vtkPolyData();
 
# Add the points to the dataset
$linesPolyData->SetPoints($pts);
 
# Add the lines to the dataset
$linesPolyData->SetLines($lines);
 
# Color the lines - associate the first component (red) of the
# colors array with the first component of the cell array (line 0)
# and the second component (green) of the colors array with the
# second component of the cell array (line 1)
$linesPolyData->GetCellData()->SetScalars($colours);
 
# Visualize
my $mapper = vtk::vtkPolyDataMapper();
$mapper->SetInputData($linesPolyData);
 
my $actor = vtk::vtkActor();
$actor->SetMapper($mapper);
 
my $renderer = vtk::vtkRenderer();
my $renderWindow = vtk::vtkRenderWindow();
$renderWindow->AddRenderer($renderer);
my $renderWindowInteractor = vtk::vtkRenderWindowInteractor();
$renderWindowInteractor->SetRenderWindow($renderWindow);
$renderer->AddActor($actor);
 
$renderWindow->Render();
$renderWindowInteractor->Start();
