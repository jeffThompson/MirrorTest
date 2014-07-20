
import java.io.BufferedWriter;      // for creating output file
import java.io.FileWriter;
import java.io.FilenameFilter;      // for getting only image files from directory

/*
CREATE COLLECTION FILE FOR OpenCV
 Jeff Thompson | 2012-14 | www.jeffreythompson.org
 
 A utillity to prepare a "collection file" for training the OpenCV library 
 to find objects based on positive images (with the object). 
 
 *** NOTE! ***
 This is not to be confused with Processing's port of the OpenCV library. 
 The full version of OpenCV must be installed via the command-line. THIS WILL
 LIKELY CAUSE OpenCV TO NOT WORK WITH PROCESSING ANY LONGER! You have been warned :)
 
 For instructions on installing OpenCV for Mac (which can be a bit tricky), see:
 http://www.jeffreythompson.org/blog/2012/09/21/installing-opencv-for-python-on-mac-lion
 
 Essentially, the collection file includes:
 +  path to each image
 +  the # of objects in the image (here we default to 1)
 +  coordinates of a rectangle's starting position
 +  width/height of the rectangle
 
 This is saved as a simple text file with spaces between entries.
 
 TO USE:
 1. All files should be in a single folder (specified when the sketch launches) in png 
 or jpg format and no larger than about 1MB
 2. The images will open one-by-one; click and drag to define the object and hit
 spacebar to save and proceed to the next (see onscreen for other commands)
 3. The resulting text file will be saved automatically as you go
 
 Note: if you update a bounding box (ie: save again) the data will be written twice
 rather than update the previous bounding box. Just an FYI.
 
 - - - - - - -
 
 TO DO:
 + Collection file will have 2x data if you update the BB - fix somehow?
 + Currently auto-resize is broken in P5, fix if possible

 */

// BASIC SETUP VARIABLES
int imageWidth =     900;    // input image size (hopefully later to be set automatically)
int imageHeight =    900;
int topUIHeight =    50;     // size of UI for top and bottom bars
int bottomUIHeight = 65;

boolean showInstructions =       false;     // show instructions at bottom (toggle with "i")
boolean resetBoundingBoxOnSave = false;     // keep the bounding box from the previous frame after saving?
int bigStep =                    10;        // how many files to jump on a "big step" (U/D arrow keys)


// OTHER VARIABLES (do not change)
boolean done =   false;              // are we all done yet?
int whichImage = 0;                  // which image are we looking at?
int numImages =  0;                  // how many images are there total?
int numStored =  0;                  // how many have been saved to the collection file? 
File[] images;                       // array of input image files
PImage img;                          // currently displayed image
boolean [] stored;                   // array to track which images have been recorded (hopefully in a separate class soon)
PrintWriter output;                  // for appending to collection file
File outputFile;                     // collection file
int x, y, w, h, ctrX, ctrY;          // coordinates and dims of bounding box
PFont font;                          // UI font
boolean altOptionPressed = false;    // is the option key pressed?


void setup() {

  // basic setup stuff
  size(imageWidth, imageHeight + topUIHeight);
  cursor(CROSS);
  //noCursor();
  frame.setTitle("Create Collection File");
  font = createFont("LucidaConsole", 64);
  textAlign(LEFT, CENTER);

  // start box offscreen (so it doesn't show up before we've made a selection)
  x = y = 0;
  mouseX = width/2;
  mouseY = height/2 + topUIHeight;

  // prepare exit handler so the file finishes saving when we quit
  prepareExitHandler();

  // open a directory of images (also creates PrintWriter for output to text file)
  selectFolder("Choose image folder...", "openDirectory");
}


void draw() {

  // gray background when no image is loaded
  if (img == null) {
    background(150);
    stroke(0);
    line(0, 0, width, height);
    line(0, height, width, 0);
  }

  // if not finished yet, draw image and interface
  else if (!done) {
    image(img, 0, topUIHeight);

    // bounding box
    if (x >= 0 && y >= 0) {
      noFill();
      stroke(0);
      rect(x, y+topUIHeight, w, h);
      stroke(255);
      rect(x+1, y+topUIHeight+1, w-2, h-2);
    }

    // crosshairs for easier editing
    if (mouseY > topUIHeight) {
      stroke(0, 100);
      line(0, mouseY, width, mouseY);
      line(mouseX, 0, mouseX, height);
      stroke(255, 100);
      line(0, mouseY-1, width, mouseY-1);
      line(mouseX+1, 0, mouseX+1, height);
    }
    
    // little box to indicate we're in center mode, center mark
    if (altOptionPressed) {
      stroke(255, 80);
      noFill();
      rectMode(CENTER);
      rect(mouseX,mouseY, 30,30);
      rectMode(CORNER);

      stroke(255);
      line(ctrX-3, ctrY + topUIHeight, ctrX+3, ctrY + topUIHeight);
      line(ctrX, ctrY + topUIHeight - 3, ctrX, ctrY + topUIHeight + 3);      
    }
    
    // draw user interface on top (hides crosshairs, etc)
    drawUI();
  }

  // if done, let us know
  else {
    background(255,150,0);    // a nice warm orange!
    fill(255);
    noStroke();
    textAlign(CENTER, CENTER);
    textFont(font, 64);
    text("ALL DONE!", width/2, height/2 - 30);
    textFont(font, 28);
    text("# of objects stored: " + nfc(numStored), width/2, height/2 + 30);
    textFont(font, 14);
    text("(have a beer, you deserve it!)", width/2, height/2 + 70);
  }
}

