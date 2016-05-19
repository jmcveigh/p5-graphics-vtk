#!/bin/perl
use warnings;
use strict;

use feature qw(say);

use Graphics::VTK;

my $points = vtk::vtkPoints();
$points->InsertNextPoint(0.0, 0.0, 0.0);
$points->InsertNextPoint(1.0, 0.0, 0.0);
$points->InsertNextPoint(1.0, 1.0, 0.0);
$points->InsertNextPoint(0.0, 1.0, 0.0);
 
my $polygon = vtk::vtkPolygon();
$polygon->GetPoints()->DeepCopy($points);
$polygon->GetPointIds()->SetNumberOfIds(4);
for (0 .. 4) {
	$polygon->GetPointIds()->SetId($_,$_);
}

my ($p1, $p2) = ([0.1, 0, -1.0],[0.1, 0, 1.0]);
my $tolerance = 0.001;
 
my $t = vtk::mutable(0);
my $x = [0.0, 0.0, 0.0];
my $pcoords = [0.0, 0.0, 0.0];
my $subId = vtk::mutable(0);
my $iD = $polygon->IntersectWithLine($p1, $p2, $tolerance, $t, $x, $pcoords, $subId);

use Data::Dumper;

say("intersected? ", $iD);
say("intersection: ", Dumper($x));
