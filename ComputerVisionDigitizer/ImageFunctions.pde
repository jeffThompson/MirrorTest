
// get frame from camera
PImage getFrame() {
  camera.read();
  PImage frame = camera.get();
  frame.resize(width, height);
  
  if (zoom > 1) {
    PImage zoomed = createImage(frame.width, frame.height, RGB);
    
    int zw = int(frame.width/zoom);
    int zh = int(frame.height/zoom);
    int zx = frame.width/2 - zw/2;
    int zy = frame.height/2 - zh/2;
    
    zoomed.copy(frame, zx,zy, zw,zh, 0,0, zoomed.width, zoomed.height);
    zoomed.resize(width, height);
    return zoomed;
  }
  else {
    return frame;
  }
}


// remove background color to create mask image 
PImage getMask(PImage f) { 
  mask = createImage(f.width, f.height, RGB);
  mask.loadPixels();
  f.loadPixels();

  for (int i=0; i<f.pixels.length; i++) {
    float r = f.pixels[i] >> 16 & 0xff;
    float g = f.pixels[i] >> 8 & 0xff;
    float b = f.pixels[i] & 0xff;
    if (r > bgR-thresh && r < bgR+thresh && g > bgG-thresh && g < bgG+thresh && b > bgB-thresh && b < bgB+thresh) {
      mask.pixels[i] = color(0);
    } else {
      mask.pixels[i] = color(255);
    }
  }
  mask.updatePixels();

  return mask;
}


// convert to grayscale, change any black pixels to (1,1,1)
PImage processFrame(PImage in, PImage m) {
  
  // create output image
  PImage f = createImage(in.width, in.height, RGB);
  f.copy(in, 0,0, in.width, in.height, 0,0, f.width, f.height);    // have to copy, otherwise filter() will be applied to original
  
  // grayscale
  f.filter(GRAY);
  
  // histogram equalization (basically auto-contrast), which helps OpenCV
  f = histogramEqualization(f);
  
  // remove any black pixels, apply the mask
  f.loadPixels();
  m.loadPixels();
  for (int i=0; i<f.pixels.length; i++) {
    if ((f.pixels[i] >> 16 & 0xff) < blackOffset) f.pixels[i] = color(blackOffset);
    if (m.pixels[i] == color(0)) f.pixels[i] = color(0);
  }
  f.updatePixels();
  
  // done!
  return f;
}


// draw with mask
void drawImageAndMask(PImage f, PImage m) {
  image(f, 0, 0);
  
  m.loadPixels();
  loadPixels();
  for (int i=0; i<m.pixels.length; i++) {
    if ((m.pixels[i] >> 16 & 0xff) == 0) {
      pixels[i] = maskColor;
    }
  }
  updatePixels();
}

