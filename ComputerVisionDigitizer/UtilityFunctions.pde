
// function to run Unix commands
boolean runUnixCommand(String[] command) {
  File dir = new File(sketchPath(""));
  String returnedValues;

  try {
    Process p = Runtime.getRuntime().exec(command, null, dir);
    int i = p.waitFor();

    // success
    if (i == 0) {
      BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
      while ( (returnedValues = stdInput.readLine ()) != null) {
        println(returnedValues);
      }
      return true;
    }

    // errors
    else {
      BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));
      while ( (returnedValues = stdErr.readLine ()) != null) {
        println(returnedValues);
      }
      return false;
    }
  }

  // if there are any other errors, let us know
  catch (Exception e) {
    println("Error running command!");  
    println(e);
    // e.printStackTrace();    // a more verbose debug, if needed
    return false;
  }
}


// utility function to copy a file to another location
void copyFile(String f1, String f2) {
  File readme = new File(f1);
  File readmeAdd = new File(f2);

  InputStream is = null;
  OutputStream os = null;

  try {
    is = new FileInputStream(readme);
    os = new FileOutputStream(readmeAdd);
    byte[] buffer = new byte[1024];
    int len;
    while ( (len = is.read (buffer)) > 0) {
      os.write(buffer, 0, len);
    }
    is.close();
    os.close();
  }
  catch (Exception e) {
    //
  }
}
