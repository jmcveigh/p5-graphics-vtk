#!/bin/perl

use strict;
use warnings;

use Graphics::VTK qw(:python);

my $sphereSource = vtk::vtkSphereSource();
$sphereSource->Update();
 
my $polydata = vtk::vtkPolyData();
$polydata->ShallowCopy($sphereSource->GetOutput());
 
my $normals = $polydata->GetPointData()->GetNormals();
$normals->SetName("Example3");
 
my $writer = vtk::vtkXMLPolyDataWriter();
$writer->SetFileName("example3_python.vtp");
$writer->SetInput($polydata);
$writer->Write();
