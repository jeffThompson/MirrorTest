
void startCamera() {
  String[] cameras = Capture.list();
  if (cameras == null || cameras.length == 0) {
    println("Couldn't find any cameras connected, quitting...");
    exit();
  } else {
    println("AVAILABLE CAMERAS:");
    for (int i=0; i<cameras.length; i++) {
      println(i + ": " + cameras[i]);
    }
    println();
  }

  // start camera object - if specified camera is attached use it 
  // otherwise, use first one listed
  try {
    camera = new Capture(this, cameras[whichCamera]);
    println("Using camera: " + cameras[whichCamera] + "\n");
  }
  catch (ArrayIndexOutOfBoundsException e) {
    println("Couldn't find specified camera...");
    println("Using: " + cameras[0] + "\n");
    camera = new Capture(this, cameras[0]);
  }
  camera.start();
}

