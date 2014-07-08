
// formats data for saving, appends to text file
void saveDetails() {
  
  // compensate for UI, make sure dimensions are not negative
  if (w <= 0 || h-topUIHeight <= 0) return;    // if the result would be negative, skip and DON'T save
  
  // convert screen coords to image coords before saving
  // saves in this format: "image-path #objects x y w h"
  String outputString = images[whichImage].getAbsolutePath() + " 1 " + x + " " + constrain(y-topUIHeight, 1, img.height-1) + " " + w + " " + constrain(h-topUIHeight, 1, img.height-1);
  appendToTextFile(outputString);

  // update bounding box variables, if specified
  // (if not, will leave for next image, which may be useful)
  if (resetBoundingBoxOnSave) {
    x = -10;    // move offscreen again
    y = -10;
    w = 0;      // reset size
    h = 0;
  }

  // keep track of if this image has been stored
  stored[whichImage] = true;

  // go to the next
  nextImage(1);
}


// add a line to a text file, create the file if necessary
void appendToTextFile(String data) {
  
  // if file doesn't already exist, make it!
  if (!outputFile.exists()) {
    File parentDir = outputFile.getParentFile();
    try {
      parentDir.mkdirs();
      outputFile.createNewFile();
    }
    catch (Exception e) {
      println("Error creating log file, quitting...");
      e.printStackTrace();
      exit();
    }
  }
  
  // write data to new line (true = append)
  try {
    output = new PrintWriter(new BufferedWriter(new FileWriter(outputFile, true)));
    output.println(data);
    output.flush();
    output.close();
  }
  
  // errors? let us know and quit
  catch(IOException ioe) {
    println("Error appending to file, quitting...");
    ioe.printStackTrace();
    exit();
  }
}
