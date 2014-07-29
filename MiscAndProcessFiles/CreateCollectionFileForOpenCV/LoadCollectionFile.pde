
// a nicety really; loads previously recorded collection
// file so you can pick up where you left off
void loadCollectionFile() {
  
  // skip if no file exists yet
  if (!outputFile.exists()) return;
  
  // load collection file
  String[] collectionFile = loadStrings(outputFile.getAbsolutePath());
  
  // check which of the images we already stored
  // (messy yes and could probably be clearer)
  for (int i=0; i<images.length; i++) {                 // go through all images (because we need the index)
    for (String line : collectionFile) {                // for each image, go see if it's in the collection file
      String path = line.split(" ")[0];                 // get just the file path from the listing
      if (path.equals(images[i].getAbsolutePath())) {   // if the two match...
        stored[i] = true;                               // ...set the 'stored' array entry to true
        numStored++;                                // and increment the count
      }
    }
  }
  
  // how many did we already have?
  println("Loaded " + numStored + " already stored images...");
}

