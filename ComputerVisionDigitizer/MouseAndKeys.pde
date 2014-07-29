
void mousePressed() {
  if (keyPressed && key == 'c') {
    rawFrame.loadPixels();
    color c = rawFrame.pixels[mouseY * width + mouseX];
    bgR = c >> 16 & 0xff;
    bgG = c >> 8 & 0xff;
    bgB = c & 0xff;
    println("Mask color: " + bgR + ", " + bgG + ", " + bgB);
  } else {
    x = ctrX = mouseX;
    y = ctrY = mouseY;
    w = h = 1;
  }
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
    } else if (x + w > width) {
      w = h = (width - ctrX) * 2;
      x = ctrX - w/2;
      y = ctrY - h/2;
    } else if (y + h > height) {
      w = h = (height - ctrY) * 2;
      x = ctrX - w/2;
      y = ctrY - h/2;
    }

    // draw a center point
    drawCenterPoint = true;
  } else {
    w = mouseX - x;
    h = mouseY - y;

    // keep aspect ratio square, select min size
    int minDim = min(w, h);

    // keep size from going offscreen
    w = constrain(minDim, 1, width-x);
    h = constrain(minDim, 1, height-y-1);

    // when hitting edges, keep from extending out of ratio
    if (w > h) w = h;
    else if (h > w) h = w;
  }

  // there is probably a cleaner way to do all this, but meh :)
}


void keyPressed() {

  // draw from center
  if (key == CODED) {
    if (keyCode == CONTROL || keyCode == ALT) altOptionPressed = true;
    else if (keyCode == 157) commandControlPressed = true;
    else if (keyCode == UP) zoom += zoomInc;
    else if (keyCode == DOWN && zoom > 1.0) zoom -= zoomInc;
  } 

  // remove bounding box
  else if (key == DELETE || key == BACKSPACE) {
    x = y = 0;
    w = h = 0;
  } 

  // ready? train it!
  else if (commandControlPressed && key == 's') {
    if (imageCount == 0) {
      JPanel panel = new JPanel();
      JLabel warning = new JLabel();
      warning.setText("<html><body><h3><strong>No, no, no!</strong></h3><p>You must capture some images before training!<p></body></html>");
      panel.add(warning);
      JOptionPane.showMessageDialog(null, panel, "Sorry!", JOptionPane.ERROR_MESSAGE);
    }
    else {
      createVectorFile();
    }
  }
  
  // take a screenshot
  else if (commandControlPressed && key == '3') {
    save("Screenshots/" + objectID + "-" + objectName + "_" + nf(imageCount, 3) + ".png");
  }


  // new settings for new object
  else if (commandControlPressed && key == 'n') {
    newObject();
  }

  // toggle raw/processed image onscreen
  else if (commandControlPressed && key == 'i') {
    showProcessedImage = !showProcessedImage;
  }

  // select largest square
  else if (commandControlPressed && key == 'a') {
    ctrX = width/2;
    ctrY = height/2;
    w = h = min(width, height);
    x = ctrX - w/2;
    y = ctrY - h/2;
  }
  
  // 1-9 = set threshold
  else if (key >= 48 && key <= 57) {
    thresh = (key - 47) * 5;      // 48 (0) - 47 * 5 = 5; 57 (9) - 47 * 5 = 50
  }

  // save image and add to collection file
  else if (key == 32) {
    String outputFilename = objectDir.getAbsolutePath() + "/SavedImages/" + nf(imageCount, 3) + ".png";
    PImage output = createImage(outputWidth, outputHeight, RGB);
    output.copy(processedFrame, x, y, w, h, 0, 0, outputWidth, outputHeight); 
    output.save(outputFilename);

    // filename #objects x y w h
    appendToTextFile("../SavedImages/" + nf(imageCount, 3) + ".png 1 " + x + " " + y + " " + w + " " + h);

    imageCount++;
  }
}


void keyReleased() {
  if (key == CODED) {
    if (keyCode == CONTROL || keyCode == ALT) {
      altOptionPressed = false;
      drawCenterPoint = false;
    } else if (keyCode == 157) {
      commandControlPressed = false;
    }
  }
}

