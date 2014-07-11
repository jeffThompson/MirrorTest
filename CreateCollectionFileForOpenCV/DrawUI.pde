
void drawUI() {

  // TOP UI
  // has the image been stored yet?
  noStroke();
  textFont(font, 32);
  textAlign(CENTER, CENTER);

  // yes: draw black box and "SAVED"
  if (stored[whichImage]) {
    fill(20);
    rect(0, 0, width, topUIHeight);
    fill(255);
    text("SAVED", width/2, topUIHeight/2);
  } 

  // no: draw red box and "NOT SAVED"
  else {
    fill(255, 0, 0);
    rect(0, 0, width, topUIHeight);
    fill(255);
    text("NOT SAVED", width/2, topUIHeight/2);
  }

  // BOTTOM UI
  fill(0, 20);
  rect(0,height-topUIHeight, width,topUIHeight);
  
  fill(255);
  noStroke();
  textFont(font, 14);
  textAlign(CENTER, CENTER);

  // instructions, if on
  if (showInstructions) {
    text("space = save  |  enter = save entire image  |  L/R = skip (U/D = skip " + bigStep + ")", width/2, height-bottomUIHeight/2);
  }

  // otherwise, current file + show # stored + bounding box dimensions
  else {
    textAlign(LEFT, CENTER);
    text(images[whichImage].getName().toUpperCase(), 20,height-bottomUIHeight/2+7);
    
    textAlign(CENTER, CENTER);
    if ((x == 0 && y == 0) || (w == 0 && h == 0)) {
      text(mouseX + "X x " + (mouseY-topUIHeight) + "Y", width/2, height-bottomUIHeight/2+7);
    }
    else {
      text(x + "X x " + y + "Y (" + w + "px)", width/2, height-bottomUIHeight/2+7);
    }
    
    textAlign(RIGHT, CENTER);
    text("STORED: " + nfc(numStored) + "/" + nfc(numImages), width-20,height-bottomUIHeight/2+7);
  }
}

