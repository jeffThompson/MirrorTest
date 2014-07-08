
// loads an array of all JPG/PNG files in specified directory
void openDirectory(File f) {

  // setup text file output
  outputFile = new File(sketchPath("") + f.getName() + "_Collection.txt");

  // get all png and jpg files
  images = f.listFiles(new FilenameFilter() {
    public boolean accept(File f, String name) {
      name = name.toLowerCase();                                        // lowercase to catch JPG and jpg
      if (name.endsWith(".png") || name.endsWith("jpg")) return true;   // if end matches extension, save
      else return false;                                                // if not, skip
    }
  });

  // how many images did we load?
  numImages = images.length;
  println("Loaded " + nfc(numImages) + " images...");
  //  println(images);
  
  // setup boolean 'stored' array (defaults to false)
  stored = new boolean[numImages];

  // load first image, resize frame to fit image, set title of window to the name of the current file
  loadImageAndResize();
  // frame.setTitle(images[whichImage].getName());
  
  // if a collection file already exists, load it
  loadCollectionFile();
}

