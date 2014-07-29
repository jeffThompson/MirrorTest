
import java.io.FilenameFilter;      // for getting only image files from directory

/*
NO BLACK PIXELS
 Jeff Thompson | 2014 | www.jeffreythompson.org
 
 A little utility that sets any black pixels (0,0,0) to just a
 nudge lighter (1,1,1).
 */


int outputWidth = 700;

boolean chosen = false;
File inputFolder;


void setup() {
  selectFolder("Choose image folder...", "openDirectory");

  size(400, 300);
  background(0);
  fill(255);
  noStroke();
  textAlign(CENTER, CENTER);
  text("Select folder...", width/2, height/2);
}


void draw() {
  if (chosen) {

    // list all image files
    File[] images = inputFolder.listFiles(new FilenameFilter() {
      public boolean accept(File f, String name) {
        name = name.toLowerCase();
        if (name.endsWith(".png") || name.endsWith(".jpg") || name.endsWith(".gif")) return true;
        else return false;
      }
    });

    // change black pixels to (1,1,1) 
    for (File f : images) {
      String imagePath = f.getAbsolutePath();
      println(imagePath);

      PImage img = loadImage(imagePath);

      if (img.width > img.height) img.resize(outputWidth, 0);
      else img.resize(0, outputWidth);

      img.filter(GRAY);
      img.loadPixels();
      for (int i=0; i<img.pixels.length; i++) {
        if ((img.pixels[i] >> 16 & 0xFF) == 0) {
          img.pixels[i] = color(1);
        }
      }
      img.updatePixels();

      img.save(imagePath);
    }

    // all done!
    exit();
  }
}


void openDirectory(File f) {
  inputFolder = f;
  chosen = true;
}

