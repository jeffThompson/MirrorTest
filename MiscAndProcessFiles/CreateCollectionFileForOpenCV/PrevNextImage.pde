
// get the next image
void nextImage(int step) {
  if (checkIfDone()) return;    // if done, skip
  
  if (whichImage + 1 > images.length - 1) whichImage = 0;
  else whichImage += step;
  
  // open image, resize frame to fit image, set title of window to the name of the current file
  loadImageAndResize();
  // frame.setTitle(images[whichImage].getName());
}


// get previous image
void previousImage(int step) {
  if (checkIfDone()) return;  // if done, skip
  
  if (whichImage-1 < 0) whichImage = images.length - 1;
  else whichImage -= step;
  
  // open image, resize frame to fit image, set title of window to the name of the current file
  loadImageAndResize();
  // frame.setTitle(images[whichImage].getName());
}

