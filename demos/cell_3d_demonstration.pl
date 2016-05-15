#!/bin/perl

use strict;
use warnings;

use Inline::Python;
use Graphics::VTK qw(:python);
 
sub build_hexagonal_prism() {
    # 3D: hexagonal prism: a wedge with an hexagonal base.
    # Be careful, the base face ordering is different from wedge.
 
    my $numberOfVertices = 12;
 
    my $points = vtk::vtkPoints();
 
    $points->InsertNextPoint(0.0, 0.0, 1.0);
    $points->InsertNextPoint(1.0, 0.0, 1.0);
    $points->InsertNextPoint(1.5, 0.5, 1.0);
    $points->InsertNextPoint(1.0, 1.0, 1.0);
    $points->InsertNextPoint(0.0, 1.0, 1.0);
    $points->InsertNextPoint(-0.5, 0.5, 1.0);
 
    $points->InsertNextPoint(0.0, 0.0, 0.0);
    $points->InsertNextPoint(1.0, 0.0, 0.0);
    $points->InsertNextPoint(1.5, 0.5, 0.0);
    $points->InsertNextPoint(1.0, 1.0, 0.0);
    $points->InsertNextPoint(0.0, 1.0, 0.0);
    $points->InsertNextPoint(-0.5, 0.5, 0.0);
 
    my $hexagonalPrism = vtk::vtkHexagonalPrism();
    for my $i (0 .. $numberOfVertices) {
		$hexagonalPrism->GetPointIds()->SetId($i,$i);
	}
 
    my $ug = vtk::vtkUnstructuredGrid();
    $ug->InsertNextCell($hexagonalPrism->GetCellType(),$hexagonalPrism->GetPointIds());
    $ug->SetPoints($points);
 
    return($ug);
}
 
sub build_hexahedron {
    # A regular hexagon (cube) with all faces square and three squares around
    # each vertex is created below.
 
    # Setup the coordinates of eight points
    # (the two faces must be in counter clockwise
    # order as viewed from the outside).
 
    # As an exercise you can modify the coordinates of the points to create
    # seven topologically distinct convex hexahedras.
    
    my $numberOfVertices = 8;
 
    # Create the points
    my $points = vtk::vtkPoints();
    $points->InsertNextPoint(0.0, 0.0, 0.0);
    $points->InsertNextPoint(1.0, 0.0, 0.0);
    $points->InsertNextPoint(1.0, 1.0, 0.0);
    $points->InsertNextPoint(0.0, 1.0, 0.0);
    $points->InsertNextPoint(0.0, 0.0, 1.0);
    $points->InsertNextPoint(1.0, 0.0, 1.0);
    $points->InsertNextPoint(1.0, 1.0, 1.0);
    $points->InsertNextPoint(0.0, 1.0, 1.0);
 
    # Create a hexahedron from the points
    my $hex_ = vtk::vtkHexahedron();
    for my $i (0 .. $numberOfVertices) {
		$hex_->GetPointIds()->SetId($i,$i);
	}
 
    # Add the points and hexahedron to an unstructured grid
    my $uGrid = vtk::vtkUnstructuredGrid();
    $uGrid->SetPoints($points);
    $uGrid->InsertNextCell($hex_->GetCellType(), $hex_->GetPointIds());
 
    return($uGrid);
}
 
sub build_pentagonal_prism {
 
    my $numberOfVertices = 10;
 
    # Create the points
    my $points = vtk::vtkPoints();
    $points->InsertNextPoint(11, 10, 10);
    $points->InsertNextPoint(13, 10, 10);
    $points->InsertNextPoint(14, 12, 10);
    $points->InsertNextPoint(12, 14, 10);
    $points->InsertNextPoint(10, 12, 10);
    $points->InsertNextPoint(11, 10, 14);
    $points->InsertNextPoint(13, 10, 14);
    $points->InsertNextPoint(14, 12, 14);
    $points->InsertNextPoint(12, 14, 14);
    $points->InsertNextPoint(10, 12, 14);
 
    # Pentagonal Prism
    my $pentagonalPrism = vtk::vtkPentagonalPrism();
    for my $i (0 .. $numberOfVertices) {
       $pentagonalPrism->GetPointIds()->SetId($i, $i);
 	}
 
    # Add the points and hexahedron to an unstructured grid
    my $uGrid = vtk::vtkUnstructuredGrid();
    $uGrid->SetPoints($points);
    $uGrid->InsertNextCell($pentagonalPrism->GetCellType(),$pentagonalPrism->GetPointIds());
 
	return($uGrid);
}
 
use Data::Dumper;

sub build_polyhedron {
	# Make a regular dodecahedron. It consists of twelve regular pentagonal
    # faces with three faces meeting at each vertex.
    
    my $numberOfFaces = 12;
 
    my $points = vtk::vtkPoints();
    $points->InsertNextPoint(1.21412, 0, 1.58931);
    $points->InsertNextPoint(0.375185, 1.1547, 1.58931);
    $points->InsertNextPoint(-0.982247, 0.713644, 1.58931);
    $points->InsertNextPoint(-0.982247, -0.713644, 1.58931);
    $points->InsertNextPoint(0.375185, -1.1547, 1.58931);
    $points->InsertNextPoint(1.96449, 0, 0.375185);
    $points->InsertNextPoint(0.607062, 1.86835, 0.375185);
    $points->InsertNextPoint(-1.58931, 1.1547, 0.375185);
    $points->InsertNextPoint(-1.58931, -1.1547, 0.375185);
    $points->InsertNextPoint(0.607062, -1.86835, 0.375185);
    $points->InsertNextPoint(1.58931, 1.1547, -0.375185);
    $points->InsertNextPoint(-0.607062, 1.86835, -0.375185);
    $points->InsertNextPoint(-1.96449, 0, -0.375185);
    $points->InsertNextPoint(-0.607062, -1.86835, -0.375185);
    $points->InsertNextPoint(1.58931, -1.1547, -0.375185);
    $points->InsertNextPoint(0.982247, 0.713644, -1.58931);
    $points->InsertNextPoint(-0.375185, 1.1547, -1.58931);
    $points->InsertNextPoint(-1.21412, 0, -1.58931);
    $points->InsertNextPoint(-0.375185, -1.1547, -1.58931);
    $points->InsertNextPoint(0.982247, -0.713644, -1.58931);
 
    # Dimensions are [numberOfFaces][numberOfFaceVertices]
    my $dodechedronFace = [
        [0, 1, 2, 3, 4],
        [0, 5, 10, 6, 1],
        [1, 6, 11, 7, 2],
        [2, 7, 12, 8, 3],
        [3, 8, 13, 9, 4],
        [4, 9, 14, 5, 0],
        [15, 10, 5, 14, 19],
        [16, 11, 6, 10, 15],
        [17, 12, 7, 11, 16],
        [18, 13, 8, 12, 17],
        [19, 14, 9, 13, 18],
        [19, 18, 17, 16, 15],
    ];
 
    my $dodechedronFacesIdList = vtk::vtkIdList();
    
    # Number faces that make up the cell.
	
    $dodechedronFacesIdList->InsertNextId($numberOfFaces);

    for my $face (@{$dodechedronFace}) {
		# die Dumper($face);
	    # Number of points in the face == numberOfFaceVertices
        $dodechedronFacesIdList->InsertNextId(scalar @{$face});
        for my $i (@{$face}) {
			$dodechedronFacesIdList->InsertNextId($i);
		}
	}

    my $uGrid = vtk::vtkUnstructuredGrid();
    $uGrid->InsertNextCell(vtk::VTK_POLYHEDRON(), $dodechedronFacesIdList);
    $uGrid->SetPoints($points);
 
    return($uGrid)
}

sub build_pyramid {
	# Make a regular square pyramid.

    my $numberOfVertices = 4;
 
    my $points = vtk::vtkPoints();

    my $p = [
         [1.0, 1.0, 0.0],
         [-1.0, 1.0, 0.0],
         [-1.0, -1.0, 0.0],
         [1.0, -1.0, 0.0],
         [0.0, 0.0, 1.0],
	];
 	
    for my $pt (@{$p}) {
		my @r = (sprintf("%.6f", $pt->[0]),sprintf("%.6f", $pt->[1]),sprintf("%.6f", $pt->[2]));
		$points->InsertNextPoint($pt->[0], $pt->[1], $pt->[2]);
	}
 
    my $pyramid = vtk::vtkPyramid();
    for my $i (0 .. $numberOfVertices) {
        $pyramid->GetPointIds()->SetId($i, $i);
	}
	
    my $unstructuredGrid = vtk::vtkUnstructuredGrid();
    $unstructuredGrid->SetPoints($points);
    $unstructuredGrid->InsertNextCell($pyramid->GetCellType(), $pyramid->GetPointIds());
 
    return($unstructuredGrid)
}
 
sub build_tetrahedron {
    # Make a tetrahedron.

    my $numberOfVertices = 4;
 
    my $points = vtk::vtkPoints();
    $points->InsertNextPoint(0, 0, 0);
    $points->InsertNextPoint(1, 0, 0);
    $points->InsertNextPoint(1, 1, 0);
    $points->InsertNextPoint(0, 1, 1);
 
    my $tetra = vtk->vtkTetra();
    for my $i (0.. $numberOfVertices) {
        $tetra->GetPointIds()->SetId($i, $i);
	}
 
    my $cellArray = vtk->vtkCellArray();
    $cellArray->InsertNextCell($tetra);
 
    my $unstructuredGrid = vtk::vtkUnstructuredGrid();
    $unstructuredGrid->SetPoints($points);
    $unstructuredGrid->SetCells(vtk::VTK_TETRA(), $cellArray);
 
    return($unstructuredGrid);
}
 
sub build_voxel {
    # A voxel is a representation of a regular grid in 3-D space.

    my $numberOfVertices = 8;
 
    my $points = vtk::vtkPoints();
    $points->InsertNextPoint(0, 0, 0);
    $points->InsertNextPoint(1, 0, 0);
    $points->InsertNextPoint(0, 1, 0);
    $points->InsertNextPoint(1, 1, 0);
    $points->InsertNextPoint(0, 0, 1);
    $points->InsertNextPoint(1, 0, 1);
    $points->InsertNextPoint(0, 1, 1);
    $points->InsertNextPoint(1, 1, 1);
 
    my $voxel = vtk::vtkVoxel();
    
    for my $i (0 .. $numberOfVertices) {
		$voxel->GetPointIds()->SetId($i, $i); 
	}
	
    my $ug = vtk->vtkUnstructuredGrid();
    $ug->SetPoints($points);
    $ug->InsertNextCell($voxel->GetCellType(), $voxel->GetPointIds());
 
    return($ug)
}
 
sub build_wedge {
	# A wedge consists of two triangular ends and three rectangular faces.
 
    my $numberOfVertices = 6;
 
    my $points = vtk::vtkPoints();
 
    $points->InsertNextPoint(0, 1, 0);
    $points->InsertNextPoint(0, 0, 0);
    $points->InsertNextPoint(0, .5, .5);
    $points->InsertNextPoint(1, 1, 0);
    $points->InsertNextPoint(1, 0.0, 0.0);
    $points->InsertNextPoint(1, .5, .5);
 
    my $wedge = vtk::vtkWedge();
    for my $i (0 .. $numberOfVertices) {
	    $wedge->GetPointIds()->SetId($i, $i);
	}
 
    my $ug = vtk::vtkUnstructuredGrid();
    $ug->SetPoints($points);
    $ug->InsertNextCell($wedge->GetCellType(), $wedge->GetPointIds());
 
    return($ug)
}
 
sub write_png {
	my ($renWin,$fn,$magnification) = (shift,shift,shift || 1);
    # Screenshot
 
    # Write out a png corresponding to the render window.
 
    # renWin - the render window.
    # fn - the file name.
    # magnification - the magnification.

    my $windowToImageFilter = vtk::vtkWindowToImageFilter();
    $windowToImageFilter->SetInput($renWin);
    $windowToImageFilter->SetMagnification($magnification);

    # Record the alpha (transparency) channel

    $windowToImageFilter->SetInputBufferTypeToRGB();
    # Read from the back buffer

    $windowToImageFilter->ReadFrontBufferOff();
    $windowToImageFilter->Update();
 
    my $writer = vtk::vtkPNGWriter();
    $writer->SetFileName($fn);
    $writer->SetInputConnection($windowToImageFilter->GetOutputPort());
    $writer->Write();
}

sub display_bodies {
    my (@titles, @text_mappers, @text_actors, @uGrids,@mappers,@actors,@renderers);
 
    push @uGrids, build_hexagonal_prism();
    push @titles, 'Hexagonal Prism';
    push @uGrids, build_hexahedron;
    push @titles, 'Hexahedron';
    push @uGrids, build_pentagonal_prism;
    push @titles, 'Pentagonal Prism';
 
    push @uGrids, build_polyhedron;
    push @titles, 'Polyhedron';
    push @uGrids, build_pyramid;
    push @titles, 'Pyramid';
    push @uGrids, build_tetrahedron;
    push @titles, 'Tetrahedron';
 
    push @uGrids, build_voxel();
    push @titles, 'Voxel';
    push @uGrids, build_wedge();
    push @titles, 'Wedge';
 
    my $renWin = vtk::vtkRenderWindow();
    $renWin->SetSize(600, 600);
    $renWin->SetWindowName('Cell3D Demonstration');
 
    my $iRen = vtk::vtkRenderWindowInteractor();
    $iRen->SetRenderWindow($renWin);
 
    # Create one text property for all
    my $textProperty = vtk::vtkTextProperty();
    $textProperty->SetFontSize(10);
    $textProperty->SetJustificationToCentered();
 
    # Create and link the mappers actors and renderers together.
    
    for my $i (0 .. $#uGrids) {
        push @text_mappers, vtk::vtkTextMapper();
        push @text_actors, vtk::vtkActor2D();
 
        push @mappers, vtk::vtkDataSetMapper();
        push @actors, vtk::vtkActor();
        push @renderers, vtk::vtkRenderer();
 
        $mappers[$i]->SetInputData($uGrids[$i]);
        $actors[$i]->SetMapper($mappers[$i]);
        $renderers[$i]->AddViewProp($actors[$i]);
 
        $text_mappers[$i]->SetInput($titles[$i]);
        $text_actors[$i]->SetMapper($text_mappers[$i]);
        $text_actors[$i]->SetPosition(50, 10);
        $renderers[$i]->AddViewProp($text_actors[$i]);
 
        $renWin->AddRenderer($renderers[$i]);
	}
	
    my $gridDimensions = 3;
    my $rendererSize = 200;
 
    $renWin->SetSize($rendererSize * $gridDimensions, $rendererSize * $gridDimensions);
 
	for my $row (0 .. $gridDimensions) {
        for my $col (0 .. $gridDimensions) {
            my $index = $row * $gridDimensions + $col;
 
            my $viewport = [
                $col * $rendererSize / ($gridDimensions * $rendererSize),
                ($gridDimensions - ($row + 1)) * $rendererSize / ($gridDimensions * $rendererSize),
                $col + 1 * $rendererSize / ($gridDimensions * $rendererSize),
                ($gridDimensions - $row) * $rendererSize / ($gridDimensions * $rendererSize),
			];
 
            if($index > scalar @actors - 1) {
                # Add a renderer even if there is no actor.
                # This makes the render window background all the same color.
                my $ren = vtk::vtkRenderer();
                $ren->SetBackground(0.2, 0.3, 0.4);
                $ren->SetViewport($viewport);
                $renWin->AddRenderer($ren);
                next;
			} else {			
				$renderers[$index]->SetViewport($viewport);
				$renderers[$index]->SetBackground(.2, .3, .4);
				$renderers[$index]->ResetCamera();
				$renderers[$index]->GetActiveCamera()->Azimuth(30);
				$renderers[$index]->GetActiveCamera()->Elevation(-30);
				$renderers[$index]->GetActiveCamera()->Zoom(0.85);
				$renderers[$index]->ResetCameraClippingRange(); 
			}
		}
	}
	
    $iRen->Initialize();
    $renWin->Render();
    return($iRen)
}
 
my $iRen = display_bodies();
$iRen->Start();
