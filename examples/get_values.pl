#!/bin perl

use strict;
use warnings;

use Graphics::VTK;

use feature 'say';

my $sphereSource = vtk::vtkSphereSource();
$sphereSource->Update();
 
my $polydata = vtk::vtkPolyData();
$polydata->ShallowCopy($sphereSource->GetOutput());
 
my $normals = $polydata->GetPointData()->GetNormals();
my @normal0 = $normals->GetTuple3(0);
 
say(($normal0[0], $normal0[1], $normal0[2]));
