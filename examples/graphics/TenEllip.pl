#!/usr/local/bin/perl -w
#
use Graphics::VTK;



use Tk;
use Graphics::VTK::Tk;
$MW = Tk::MainWindow->new;

$VTK_DATA = 0;
$VTK_DATA = $ENV{VTK_DATA};
# get the interactor ui
use Graphics::VTK::Tk::vtkInt;
# create tensor ellipsoids
# Create the RenderWindow, Renderer and interactive renderer
$ren1 = Graphics::VTK::Renderer->new;
$renWin = Graphics::VTK::RenderWindow->new;
$renWin->AddRenderer($ren1);
$iren = Graphics::VTK::RenderWindowInteractor->new;
$iren->SetRenderWindow($renWin);
# Create tensor ellipsoids
# generate tensors
$ptLoad = Graphics::VTK::PointLoad->new;
$ptLoad->SetLoadValue(100.0);
$ptLoad->SetSampleDimensions(6,6,6);
$ptLoad->ComputeEffectiveStressOn;
$ptLoad->SetModelBounds(-10,10,-10,10,-10,10);
# extract plane of data
$plane = Graphics::VTK::StructuredPointsGeometryFilter->new;
$plane->SetInput($ptLoad->GetOutput);
$plane->SetExtent(2,2,0,99,0,99);
# Generate ellipsoids
$sphere = Graphics::VTK::SphereSource->new;
$sphere->SetThetaResolution(8);
$sphere->SetPhiResolution(8);
$ellipsoids = Graphics::VTK::TensorGlyph->new;
$ellipsoids->SetInput($ptLoad->GetOutput);
$ellipsoids->SetSource($sphere->GetOutput);
$ellipsoids->SetScaleFactor(10);
$ellipsoids->ClampScalingOn;
$ellipNormals = Graphics::VTK::PolyDataNormals->new;
$ellipNormals->SetInput($ellipsoids->GetOutput);
# Map contour
$lut = Graphics::VTK::LogLookupTable->new;
$lut->SetHueRange('.6667',0.0);
$ellipMapper = Graphics::VTK::PolyDataMapper->new;
$ellipMapper->SetInput($ellipNormals->GetOutput);
$ellipMapper->SetLookupTable($lut);
$plane->Update;
#force update for scalar range
$ellipMapper->SetScalarRange($plane->GetOutput->GetScalarRange);
$ellipActor = Graphics::VTK::Actor->new;
$ellipActor->SetMapper($ellipMapper);
# Create outline around data
$outline = Graphics::VTK::OutlineFilter->new;
$outline->SetInput($ptLoad->GetOutput);
$outlineMapper = Graphics::VTK::PolyDataMapper->new;
$outlineMapper->SetInput($outline->GetOutput);
$outlineActor = Graphics::VTK::Actor->new;
$outlineActor->SetMapper($outlineMapper);
$outlineActor->GetProperty->SetColor(0,0,0);
# Create cone indicating application of load
$coneSrc = Graphics::VTK::ConeSource->new;
$coneSrc->SetRadius('.5');
$coneSrc->SetHeight(2);
$coneMap = Graphics::VTK::PolyDataMapper->new;
$coneMap->SetInput($coneSrc->GetOutput);
$coneActor = Graphics::VTK::Actor->new;
$coneActor->SetMapper($coneMap);
$coneActor->SetPosition(0,0,11);
$coneActor->RotateY(90);
$coneActor->GetProperty->SetColor(1,0,0);
$camera = Graphics::VTK::Camera->new;
$camera->SetFocalPoint(0.113766,-1.13665,-1.01919);
$camera->SetPosition(-29.4886,-63.1488,26.5807);
$camera->ComputeViewPlaneNormal;
$camera->SetViewAngle(24.4617);
$camera->SetViewUp(0.17138,0.331163,0.927879);
$camera->SetClippingRange(1,100);
$ren1->AddActor($ellipActor);
$ren1->AddActor($outlineActor);
$ren1->AddActor($coneActor);
$ren1->SetBackground(1.0,1.0,1.0);
$ren1->SetActiveCamera($camera);
$renWin->SetSize(450,450);
$renWin->Render;
$iren->SetUserMethod(
 sub
  {
   $MW->{'.vtkInteract'}->deiconify;
  }
);
#renWin SetFileName TenEllip.tcl.ppm
#renWin SaveImageAsPPM
# prevent the tk window from showing up then start the event loop
$MW->withdraw;
Graphics::VTK::Tk::vtkInt::vtkInteract($MW);

Tk->MainLoop;
