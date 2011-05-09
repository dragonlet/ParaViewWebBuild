import os
import paraview

buildDir = os.getenv('ParaView_DIR',"")
 
paraview.simple.LoadPlugin(buildDir+"/libMantaView.so", False)
paraview.simple.LoadPlugin(buildDir+"/libMantaView.so", True)
 
paraview.simple.active_objects.view = paraview.simple._create_view("MantaIceTDesktopRenderView")
paraview.simple.active_objects.view.Threads = 8
paraview.simple.active_objects.view.ViewSize = [600,600]

