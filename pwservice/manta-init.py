import paraview
 
 buildDir = '.../ParaView-build/bin'
 
 paraview.simple.LoadPlugin(buildDir+"/libMantaView.so", False)
 paraview.simple.LoadPlugin(buildDir+"/libMantaView.so", True)
 
 paraview.simple.active_objects.view = paraview.simple._create_view("MantaIceTDesktopRenderView")
 paraview.simple.active_objects.view.Threads = 8
 paraview.simple.active_objects.view.ViewSize = [300,300]

