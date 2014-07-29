
void makeBook() {

  // load cascade file
  String[] collection = loadStrings(objectDir.getAbsolutePath() + "/CascadeFiles/cascade.xml");

  // create output font, determine # of characters/line
  PFont outputFont = createFont("OCRB", outputFontSize);
  int charsWide = int((pageWidth - (marginLeft * 2)) / (outputFontSize*0.71));

  // initialize PDF, basic settings
  PGraphics pdf = createGraphics(pageWidth, pageHeight, PDF, objectDir.getAbsolutePath() + "/Cascade.pdf");
  pdf.beginDraw();

  // position variables
  int ty = marginTop;
  int tx = marginLeft;
  int pageCount = 0;

  // first page is a grid of images of the object
  File[] imagesOfObject = new File(objectDir.getAbsolutePath() + "/SavedImages").listFiles(new FilenameFilter() {
    public boolean accept(File imagesOfObject, String name) {
      name = name.toLowerCase();
      if (name.endsWith(".png") || name.endsWith(".jpg")) return true;
      else return false;
    }
  });
  
  int imageDim = (pageWidth - (marginLeft*2)) / 3;
  for (int iy=0; iy<5; iy++) {
    for (int ix=0; ix<3; ix++) {
      try {
        PImage obj = loadImage(imagesOfObject[iy * 3 + ix].getAbsolutePath());
        obj.resize(imgW, imgH);                                                                  // resize to size used in training
        pdf.image(obj, tx + (imageDim * ix) + 2, ty + (imageDim * iy) + 2, imageDim, imageDim);  // draw to screen, adding a little padding (2px)
      }
      catch (Exception e) {
        // we've run out of images, leave blank
      }
    }
  }

  // update position to next page
  pageCount++;
  PGraphicsPDF pdfOutput = (PGraphicsPDF) pdf;
  pdfOutput.nextPage();

  // go through cascade file, make PDF
  pdf.textFont(outputFont, outputFontSize);
  pdf.textAlign(LEFT, TOP);
  pdf.fill(0);
  pdf.noStroke();
  for (int i=0; i<collection.length; i++) {

    // get indentation for current line
    String indent = "";
    for (int j=0; j<collection[i].length (); j++) {
      if (collection[i].charAt(j) != ' ') break;
      else indent += " ";
    }

    // split and write to file
    StringList lines = splitLines(collection[i], charsWide, indent);
    for (int j=0; j<lines.size (); j++) {
      pdf.text(lines.get(j), tx, ty);
      ty += lineSpacing;

      // start new page, if necessary
      if (ty > pdf.height - (marginTop * 2)) {
        ty = marginTop;
        pageCount++;

        pdfOutput = (PGraphicsPDF) pdf;
        pdfOutput.nextPage();
      }
    }
  }

  // all done, close PDF
  pdf.dispose();
  pdf.endDraw();

  // merge with other PDF files - then we're done!
  String[] command = {
    "/usr/local/bin/gs", 
    "-dBATCH", "-dNOPAUSE", "-q", 
    "-sDEVICE=pdfwrite", 

    // output file
    "-sOutputFile=" + objectDir.getAbsolutePath() + "/" + objectID + "-" + objectName + ".pdf", 

    // combine with title page, etc
    sketchPath("") + "BookFiles/TitlePageAndEssay.pdf", 
    objectDir.getAbsolutePath() + "/Cascade.pdf", 
    sketchPath("") + "BookFiles/EndPage.pdf",
  };
  boolean success = runUnixCommand(command);
  if (success) bookMade = true;

  // finally, delete Cascade.pdf file
  try {
    File del = new File(objectDir.getAbsolutePath() + "/Cascade.pdf");
    del.delete();
  }
  catch (Exception e) {
    //
  }
  
  done = true;
}


// based on this example by Daniel Shiffman: http://wiki.processing.org/w/Word_wrap_text
StringList splitLines(String s, int maxWidth, String indent) {

  StringList output = new StringList();    // list of lines to output
  int w = 0;                               // accumulating # of chars
  int rememberSpace = 0;                   // where did we last have a space?

  // go through chars until we're done with the string
  int i = 0;
  while (i < s.length ()) {
    char c = s.charAt(i);               // get current character
    if (c == ' ') rememberSpace = i;    // is this a space?

    // increment width, if past dim, break line
    w += 1;
    if (w > maxWidth) {
      String out = s.substring(0, i);
      output.append(out);

      // create new string (with indenting), reset variables
      s = indent + s.substring(i, s.length());
      i = 0;
      w = 0;
    } else {
      i++;
    }
  }

  // tack on remaining line
  if (s.length() > 0) s = s.substring(0, s.length());
  output.append(s);

  // all done!
  return output;
}  

