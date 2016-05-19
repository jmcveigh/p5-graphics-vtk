#!/bin/perl

use strict;
use warnings;

use Graphics::VTK;

my @GeometricObjects;
push @GeometricObjects,vtk::vtkArrowSource();
push @GeometricObjects,vtk::vtkConeSource();
push @GeometricObjects,vtk::vtkCubeSource();
push @GeometricObjects,vtk::vtkCylinderSource();
push @GeometricObjects,vtk::vtkDiskSource();
push @GeometricObjects,vtk::vtkLineSource();
push @GeometricObjects,vtk::vtkRegularPolygonSource();
push @GeometricObjects,vtk::vtkSphereSource();
push @GeometricObjects,vtk::vtkLineSource();
 
my (@Renderers,@Mappers,@Actors,@TextMappers,@TextActors);
my $TextProperty = vtk::vtkTextProperty();
$TextProperty->SetFontSize(10);
$TextProperty->SetJustificationToCentered();
 
for(my $idx = 0;$idx < $#GeometricObjects + 1; $idx++) {
	$GeometricObjects[$idx]->Update(); 
	
	push @Mappers,vtk::vtkPolyDataMapper();
	$Mappers[$idx]->SetInputConnection($GeometricObjects[$idx]->GetOutputPort());

	push @Actors, vtk::vtkActor();
	$Actors[$idx]->SetMapper($Mappers[$idx]);

	push @TextMappers, vtk::vtkTextMapper();
	$TextMappers[$idx]->SetInput($GeometricObjects[$idx]->GetClassName());
	$TextMappers[$idx]->SetTextProperty($TextProperty);

	push @TextActors, vtk::vtkActor2D();
	$TextActors[$idx]->SetMapper($TextMappers[$idx]);
	$TextActors[$idx]->SetPosition(150, 16);

	push @Renderers, vtk::vtkRenderer();
}
 
my $gridDimensions = 3;
 
for my $idx (0 .. $#GeometricObjects + 1) {
	if ($idx < $gridDimensions * $gridDimensions) {
		push @Renderers, vtk::vtkRenderer();
	}
} 
my $rendererSize = 300;

my $renderWindow = vtk::vtkRenderWindow();
$renderWindow->SetSize($rendererSize * $gridDimensions, $rendererSize * $gridDimensions);
my @Viewport;

for my $row (0 .. $gridDimensions) {
	for my $col (0 .. $gridDimensions) {
		my $idx = $row * $gridDimensions + $col;

		my $Viewport = [
			(sprintf("%f",$col) * $rendererSize / ($gridDimensions * $rendererSize)),
			sprintf("%f",$gridDimensions - ($row+1)) * $rendererSize / ($gridDimensions * $rendererSize),
			sprintf("%f",$col+1)*$rendererSize / ($gridDimensions * $rendererSize),
			(sprintf("%f",$gridDimensions - $row) * $rendererSize / ($gridDimensions * $rendererSize)),
		];

		next if ($idx > ($#GeometricObjects));

		$Renderers[$idx]->SetViewport($Viewport);
		$renderWindow->AddRenderer($Renderers[$idx]);

		$Renderers[$idx]->AddActor($Actors[$idx]);
		$Renderers[$idx]->AddActor($TextActors[$idx]);
		$Renderers[$idx]->SetBackground(0.4,0.3,0.2);
	}
}
    
my $interactor = vtk::vtkRenderWindowInteractor();
$interactor->SetRenderWindow($renderWindow);
 
$renderWindow->Render(); 
$interactor->Start();
