
// handles as user interaction

// mouse click starts the object bounding-box; drag to define size
void mousePressed() {
  x = mouseX;
  x = constrain(x, 0, imageWidth-1);
  
  y = mouseY - topUIHeight;
  y = constrain(y, 0, imageHeight-1);
  
  w = 0;
  h = 0;
}
void mouseDragged() {
  w = constrain(mouseX - x, 1, imageWidth-x);      // keep size from going offscreen
  
  h = mouseY - y - topUIHeight;
  h = constrain(h, 1, imageHeight-y-1);
}


// keys are listed below
void keyPressed() {

  // L/R arrow keys move to next image without storing, up/down skips 10 images
  if (key == CODED) {
    if (keyCode == RIGHT)     nextImage(1);
    else if (keyCode == UP)   nextImage(bigStep);
    else if (keyCode == LEFT) previousImage(1);
    else if (keyCode == DOWN) previousImage(bigStep);
  }

  // spacebar stores and moves ahead
  else if (key == 32) {
    saveDetails();
  }

  // enter/return selects the entire image and moves ahead
  else if (key == RETURN || key == ENTER) {
    x = 0;
    y = 0;
    w = img.width;
    h = img.height;
    saveDetails();      // save and go to next image
  }
  
  // letter "i" toggles instructions
  else if (key == 'i') {
    showInstructions = !showInstructions;
  }

  // letter "p" to print remaining images to store
  else if (key == 'p') {
    checkIfDone();
    println("\n" + "IMAGES NOT STORED:");
    for (int i=0; i<numImages; i++) {
      if (!stored[i]) {
        println("  " + i);     // if not stored, print index
      }
    }
    println("\n" + nfc(images.length - numStored) + " left to store");
    println("\n" + "- - - - - - - -");
  }
  
  // letter "s" to save a frame of the app
  else if (key == 's') {
    save("Screenshots/CreateCollectionFile_" + nf(whichImage, 6) + ".png");
  }
}

