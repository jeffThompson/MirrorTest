
void makeBook() {
  
  // create output font
  PFont outputFont = createFont("OCRB", outputFontSize);
  
  // customized cover page
  PGraphics pdf = createGraphics(pageWidth, pageHeight, PDF, objectDir.getAbsolutePath() + "/TitlePage.pdf");
  pdf.beginDraw();
  pdf.fill(110);
  pdf.noStroke();
  
  // Aztec code
  PImage aztecCode = loadImage(sketchPath("") + "BookFiles/TitlePageAztecCode.gif");
  pdf.imageMode(CENTER);
  pdf.image(aztecCode, pageWidth/2, pageHeight/2 - 60, 144,144);    // 2" square
  
  // title, object name, and date
  pdf.textAlign(CENTER, CENTER);
  pdf.textFont(outputFont, 36);
  pdf.text("MIRROR TEST", pageWidth/2, pageHeight/2 + 60);
  pdf.textFont(outputFont, outputFontSize);
  pdf.text(objectID + ": " + pdfObjectName, pageWidth/2, pageHeight/2 + 95);
  pdf.text(year(), pageWidth/2, pageHeight - (marginTop*2));
  
  // blank page
  PGraphicsPDF pdfOutput = (PGraphicsPDF) pdf;
  pdfOutput.nextPage();
  
  // close PDF
  pdf.dispose();
  pdf.endDraw();


  // load cascade file, determine # of characters/line for breaks
  String[] collection = loadStrings(objectDir.getAbsolutePath() + "/CascadeFiles/cascade.xml");
  int charsWide = int((pageWidth - (marginLeft * 2)) / (outputFontSize*0.71));
  
  // initialize PDF, basic settings
  pdf = createGraphics(pageWidth, pageHeight, PDF, objectDir.getAbsolutePath() + "/Cascade.pdf");
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
  for (int iy=0; iy<4; iy++) {
    for (int ix=0; ix<3; ix++) {
      try {
        PImage obj = loadImage(imagesOfObject[iy * 3 + ix].getAbsolutePath());
        pdf.noSmooth();    // get those crisp pixels!
        obj.resize(imgW, imgH);                                                                      // resize to size used in training
        pdf.image(obj, tx + ((imageDim+2) * ix), ty + ((imageDim+2) * iy) + 2, imageDim, imageDim);  // draw to screen, adding a little padding (2px)
        pdf.smooth();      // set back for fonts
      }
      catch (Exception e) {
        // we've run out of images, leave blank
      }
    }
  }

  // update position to next page
  pageCount++;
  pdfOutput = (PGraphicsPDF) pdf;
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
  
  // are we at an even # of pages? if not, add one more
  if (pageCount % 2 != 0) {
    pdfOutput = (PGraphicsPDF) pdf;
    pdfOutput.nextPage();
  }

  // close PDF
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
    objectDir.getAbsolutePath() + "/TitlePage.pdf",
    sketchPath("") + "BookFiles/Essay.pdf", 
    objectDir.getAbsolutePath() + "/Cascade.pdf", 
    sketchPath("") + "BookFiles/EndPage.pdf",
  };
  boolean success = runUnixCommand(command);
  if (success) bookMade = true;

  // finally, delete title page and cascade PDF files
  try {
    File del = new File(objectDir.getAbsolutePath() + "/TitlePage.pdf");
    del.delete();
    
    del = new File(objectDir.getAbsolutePath() + "/Cascade.pdf");
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

