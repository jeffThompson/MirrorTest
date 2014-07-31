
void drawUI() {

  // bounding box
  if (w > 0 && h > 0) {
    noFill();
    stroke(0);
    rect(x, y, w, h);

    // darken unselected areas
    fill(0, 150);
    noStroke();
    rect(0, 0, width, y);                   // top
    rect(0, height, width, -(height-h-y));  // bottom
    rect(0, y, x, h);                       // left
    rect(x+w, y, width-w-x, h);             // right
  }

  // crosshairs for easier editing
  stroke(0, 100);
  line(0, mouseY, width, mouseY);
  line(mouseX, 0, mouseX, height);
  stroke(255, 100);
  line(0, mouseY-1, width, mouseY-1);
  line(mouseX+1, 0, mouseX+1, height);

  // little box to indicate we're in center mode
  if (altOptionPressed) {
    stroke(255, 80);
    noFill();
    rectMode(CENTER);
    rect(mouseX, mouseY, 30, 30);
    rectMode(CORNER);

    if (drawCenterPoint) {
      stroke(255);
      line(ctrX-3, ctrY, ctrX+3, ctrY);
      line(ctrX, ctrY-3, ctrX, ctrY+3);
    }
  }
  
  if (done) {
    fill(255,0,0, 150);
    noStroke();
    rect(0,0, width,height);
    
    fill(255);
    textFont(font, 64);
    textAlign(CENTER, CENTER);
    text("DONE!", width/2,height/2);
  }

  // show current object details, bounding box coords, how many images stored
  fill(255);
  noStroke();
  textFont(font, 16);
  textAlign(LEFT, TOP);
  text(objectID + ": " + pdfObjectName, 20, 20);    // use print version of name

  textAlign(LEFT, BOTTOM);
  String s = "Bounds: " + x + "x " + y + "y (" + w + "px)" + "\n";
  s       += "Zoom:   " + nf(zoom, 0,2) + "\n";
  s       += "Mask:   " + int(bgR) + ", " + int(bgG) + ", " + int(bgB) + "\n";
  s       += "Thresh: " + thresh;
  
  if (vectorFileCreated) s += "\n\n" + "VECTOR FILE CREATED";
  if (cascadeTrained) s += "\n" + "CASCADE TRAINED";
  if (bookMade) s+= "\n" + "BOOK MADE - DONE!";
  
  text(s, 20, height-20);

  textFont(font, 48);
  textAlign(RIGHT, BOTTOM);
  text(nf(imageCount, 3), width-20, height-20);
}

