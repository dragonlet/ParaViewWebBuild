var paraview = new Paraview(serverUrl);
paraview.createSession("name", "comment");
paraview.loadPlugins();
calc = paraview.plugins.calc;
calc.add(5,2);
mantaLoader = paraview.plugins.MantaLoader;
view = mantaLoader.createMantaView();
