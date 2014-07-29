
// add a line to a text file, create the file if necessary
void appendToTextFile(String data) {
  
  // if file doesn't already exist, make it!
  outputFile = new File(objectDir.getAbsolutePath() + "/CollectionFiles/" + objectID + "-" + objectName + ".txt");
  if (!outputFile.exists()) {
    try {
      outputFile.getParentFile().mkdirs();
      outputFile.createNewFile();
    }
    catch (Exception e) {
      println("Error creating log file, quitting...");
      e.printStackTrace();
      exit();
    }
  }
  
  // write data to new line (true = append)
  try {
    PrintWriter output = new PrintWriter(new BufferedWriter(new FileWriter(outputFile, true)));
    output.println(data);
    output.flush();
    output.close();
  }
  
  // errors? let us know and quit
  catch(IOException ioe) {
    println("Error appending to file, quitting...");
    ioe.printStackTrace();
    exit();
  }
}

