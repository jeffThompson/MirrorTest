
// mouse click starts the object bounding-box
void mousePressed() {
  x = mouseX;                          // set upper-left corner
  x = constrain(x, 0, imageWidth-1);   // keep onscreen
  ctrX = x;                            // for center bb

  y = mouseY - topUIHeight;
  y = constrain(y, 0, imageHeight-1);
  ctrY = y;  

  w = 0;
  h = 0;
}


// when released, move center offscreen
void mouseReleased() {
  ctrX = ctrY = -10;
}


// drag to define bounding-box size
void mouseDragged() {

  if (altOptionPressed) {

    int minDim = min(mouseX - ctrX, mouseY - ctrY);
    x = ctrX - minDim;
    y = ctrY - minDim;
    w = h = minDim * 2;

    // keep onscreen
    if (x < 0) {
      x = 0;
      y = ctrY - ctrX;
      w = h = ctrX * 2;
    } else if (y < 0) {
      y = 0;
      x = ctrX - ctrY;
      w = h = ctrY * 2;
    } else if (x + w > imageWidth) {
      w = h = (imageWidth - ctrX) * 2;
      x = ctrX - w/2;
      y = ctrY - h/2;
    } else if (y + h > imageHeight) {
      w = h = (imageHeight - ctrY) * 2;
      x = ctrX - w/2;
      y = ctrY - h/2;
    }
  } else {
    // use image coords, not screen (because of UI at top)
    w = mouseX - x;
    h = mouseY - y - topUIHeight;

    // keep aspect ratio square, select min size
    int minDim = min(w, h);

    // keep size from going offscreen
    w = constrain(minDim, 1, imageWidth-x);
    h = constrain(minDim, 1, imageHeight-y-1);

    // when hitting edges, keep from extending out of ratio
    if (w > h) w = h;
    else if (h > w) h = w;
  }

  // there is probably a cleaner way to do all this, but meh :)
}


// keys are listed below
void keyPressed() {

  if (key == CODED) {

    // L/R arrow keys move to next image without storing, up/down skips 10 images
    if (keyCode == RIGHT)     nextImage(1);
    else if (keyCode == UP)   nextImage(bigStep);
    else if (keyCode == LEFT) previousImage(1);
    else if (keyCode == DOWN) previousImage(bigStep);

    // alt/option key toggles bounding-box mode
    else if (keyCode == CONTROL || keyCode == ALT) {
      altOptionPressed = true;
    }
  }

  // delete key resets bounding box
  else if (key == DELETE || key == BACKSPACE) {
    x = y = 0;
    w = h = 0;
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

// alt/option key toggles bounding-box mode
void keyReleased() {
  if (keyCode == CONTROL || keyCode == ALT) {
    altOptionPressed = false;
  }
}

