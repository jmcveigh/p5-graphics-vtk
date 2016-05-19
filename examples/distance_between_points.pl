#!/bin/perl

use strict;
use warnings;

use feature 'say';

use Graphics::VTK;

my ($p0,$p1) = (
	[0,0,0],
	[1,1,1]
);

my $math = vtk::vtkMath();

my $dist_squared = $math->Distance2BetweenPoints($p0,$p1);
 
my $dist = sqrt($dist_squared);
 
say("p0 = ", @{$p0});
say("p1 = ", @{$p1});
say("distance squared = ", $dist_squared);
say("distance = ", $dist);
