
import java.io.FilenameFilter;      // for getting only image files from directory

/*
NO BLACK PIXELS
 Jeff Thompson | 2014 | www.jeffreythompson.org
 
 A little utility that sets any black pixels (0,0,0) to just a
 nudge lighter (1,1,1).
 */


File inputFolder = new File("/Users/JeffThompson/Documents/MirrorTest/MacBookPro_Front/");

void setup() {

  // list all image files
  File[] images = inputFolder.listFiles(new FilenameFilter() {
    public boolean accept(File f, String name) {
      name = name.toLowerCase();
      if (name.endsWith(".png") || name.endsWith(".jpg")) return true;
      else return false;
    }
  }
  );

  // change black pixels to (1,1,1) 
  for (File f : images) {
    String imagePath = f.getAbsolutePath();
    println(imagePath);

    PImage img = loadImage(imagePath);
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

