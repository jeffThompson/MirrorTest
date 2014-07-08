
void drawUI() {

  // TOP UI
  // has the image been stored yet?
  noStroke();
  textFont(font, 32);
  textAlign(LEFT, CENTER);

  // yes: draw black box and "SAVED"
  if (stored[whichImage]) {
    fill(20);
    rect(0, 0, width, topUIHeight);

    fill(255);
    textAlign(LEFT, CENTER);
    text("SAVED", 20, topUIHeight/2);
  } 

  // no: draw red box and "NOT SAVED"
  else {
    fill(255, 0, 0);
    rect(0, 0, width, topUIHeight);

    fill(255);
    textAlign(LEFT, CENTER);
    text("NOT SAVED", 20, topUIHeight/2);
  }

  // filename in center
  fill(255);
  textFont(font, 16);
  textAlign(CENTER, CENTER);
  text(images[whichImage].getName().toUpperCase(), width/2, topUIHeight/2);

  // bounding box dimensions
  fill(255);
  noStroke();
  textAlign(RIGHT, CENTER);
  textFont(font, 32);
  
  // show starting point and w/h
  if ((w > 0 && y > 0) || mousePressed) {
    text(x + "x" + y + ", " + w + "x" + h, width-20, topUIHeight/2);
  }
  // just show current mouse coords (also offset for UI)
  else {
    text(constrain(mouseX, 0, img.width-1) + "x" + constrain(mouseY-topUIHeight, 0, img.height-1), width-20, topUIHeight/2);
  }

  // BOTTOM UI
  // instructions, if on
  if (showInstructions) {
    fill(255);
    noStroke();
    textFont(font, 14);
    textAlign(CENTER, CENTER);
    text("space = save  |  enter = save entire image  |  L/R = skip (U/D = skip " + bigStep + ")  |  stored: " + nfc(numStored) + " / " + nfc(numImages), width/2, height-bottomUIHeight/2);
  }
}

