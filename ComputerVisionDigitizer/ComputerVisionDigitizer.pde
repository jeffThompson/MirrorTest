
import processing.video.*;           // for getting image from webcam
import java.io.BufferedWriter;       // for creating output file
import java.io.FileWriter;

import javax.swing.JOptionPane;      // for changing computer ID/name through a dialog box
import javax.swing.JPanel;
import java.awt.GridLayout;
import javax.swing.JTextField;
import javax.swing.JLabel;

import java.io.InputStreamReader;    // part of running training commands
import java.io.FileInputStream;      // for copying README file
import java.io.FileOutputStream;
import processing.pdf.*;             // for writing book file

import java.io.FilenameFilter;       // for getting only image files from directory


/*
COMPUTER VISION DIGITIZER
Jeff Thompson | 2014 | www.jeffreythompson.org

A utility for capturing images of objects for training computer vision. Select
a bounding box and background color to remove, hit spacebar to record the image
both to a file and to a collection file! Command+S to train the cascade and
create a book file.

Time saved = more beers.


KEYBOARD COMMANDS:
space            save image and collection file
click+c          hold down 'c' when clicking to select keying color
command+i        toggle between raw and processed image
command+n        new object (lets you input a new ID and name)
command+s        train the cascade, create book
command+3        take a screenshot of the interface (does not record to collection)
delete           clear bounding box
up/down          digital zoom


BORROWED FROM:
+  Popup dialog box: 
     http://forum.processing.org/two/discussion/4764/how-to-make-a-popup-window/p1
+  Histogram equalization:
     http://zerocool.is-a-geek.net/java-image-histogram-equalization


TO DO:
+  Count pages, add blank if necessary
+  Customized cover page?


*/

int thresh =           25;                 // color range +/- to select color for background
color maskColor =      color(0, 255, 0);   // onscreen color to show chroma key
color blackOffset =    5;                  // anything under this value will be bumped up

int outputWidth =      300;                // how large to save selection
int outputHeight =     300;                // should be square, will auto-set if not
float zoomInc=         0.25;               // how much to zoom each press of the arrow keys

int whichCamera =      15;                 // ID of camera from input list (0 is usually built-in webcam)

int numNeg =           100;                // cascade training variables
int numStages =        10;
int memoryAllocation = 4000;               // max RAM use (in MB)
float acceptRate =     0.9;
int imgW =             24;
int imgH =             24; 
int bgColor =          0;                  // color to ignore (grayscale)
int bgThresh =         2;                  // +/- background color

boolean isSymmetrical = true;
String negativeImageList = "NegativeImages.txt";

int outputFontSize =   10;                 // PDF font size (in px)
int lineSpacing =      14;                 // space between lines (also in px)
int pageWidth =        int(5.5 * 72);      // page setup (x72dpi = print res)
int pageHeight =       int(8.5 * 72);
int marginLeft =       int(0.5 * 72);
int marginTop =        int(0.5 * 72);


String objectID, objectName;              // a unique ID and a (not necessarily unique) name for the object
File objectDir;                           // location for storing all details for the object
PImage rawFrame, processedFrame, mask;    // images loaded, processed, and chroma-key masking
Capture camera;                           // for webcam input
File outputFile;                          // collection file
float bgR, bgG, bgB;                      // currently selected color to key out
int x, y, w, h, ctrX, ctrY;               // bounding box position and dimensions
PFont font;                               // UI font
int imageCount = 0;                       // how many images have we recorded of this object?
float zoom = 1.0;                         // amount to zoom the incoming image
boolean altOptionPressed = false;         // alt key draws bounding box from center
boolean commandControlPressed = false;    // command/control for keyboard shortcuts
boolean drawCenterPoint = false;          // flag to show center point of box
boolean showProcessedImage = false;       // toggle between raw/processed image
boolean vectorFileCreated = false;        // have we created a vector file yet?
boolean cascadeTrained = false;
boolean bookMade = false;
boolean done = false;


void setup() {  
  size(displayWidth, displayHeight);
  frame.setTitle("Computer Vision Digitizer");
  frame.setResizable(true);
  font = createFont("LucidaConsole", 64);

  // setup bg color and bounding box
  bgR = bgG = bgB = 0;
  x = y = 0;
  
  // output setup (just in case output size isn't square, create collection file)
  outputWidth = outputHeight = max(outputWidth, outputHeight);
  
  // new object file and start camera
  startCamera();
  newObject();
}


void draw() {
  if (camera.available() == true) {
    rawFrame = getFrame();                          // get frame of video
    mask = getMask(rawFrame);                       // create mask from ignored bg color
    processedFrame = processFrame(rawFrame, mask);  // grayscale, remove black, apply mask
    
    // display the camera image (processed or raw), with mask
    if (showProcessedImage) drawImageAndMask(processedFrame, mask);
    else drawImageAndMask(rawFrame, mask);
    
    // using this structure let's us see the progress onscreen
    if (vectorFileCreated && !cascadeTrained) trainCascade();
    else if (cascadeTrained && !bookMade) makeBook();
    
    // interface with object ID/name and image count
    drawUI();
  }
}

