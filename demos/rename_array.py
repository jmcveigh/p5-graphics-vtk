#!/usr/local/bin/env python
import vtk
from vtk import *
 
#setup sphere
sphereSource = vtk.vtkSphereSource()
sphereSource.Update()
 
polydata = vtk.vtkPolyData()
polydata.ShallowCopy(sphereSource.GetOutput())
 
normals = polydata.GetPointData().GetNormals()
normals.SetName("Example3")
 
writer = vtk.vtkXMLPolyDataWriter()
writer.SetFileName("example3_python.vtp")
writer.SetInput(polydata)
writer.Write()
