
// loads the image, set variables as needed, and (soon,
// hopefully) updates the window size to match
void loadImageAndResize() {
  img = loadImage(images[whichImage].getAbsolutePath());
  imageWidth = img.width;
  imageHeight = img.height;

  // resize window to fit image
  // note we have to both use both:
  // setSize() to actually change the window's size, and
  // size() so we can access 'width' and 'height' elsewhere
  frame.setResizable(true);
  // frame.setSize(imageWidth, imageHeight + topUIHeight);
  // size(imageWidth, imageHeight + topUIHeight);
  frame.setResizable(false);

  // println("- " + imageWidth + "x" + imageHeight + "px (" + width + "x" + height + " overall)");
}

