
// close output file on exit
// via: https://forum.processing.org/topic/run-code-on-exit
void prepareExitHandler () {
  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
    public void run() {
      try {

        // just close the file to ensure data is all written
        output.flush();
        output.close();
        stop();
      } 
      catch (Exception e) {
        // will throw an error if the output file doesn't exist
        // we just ignore it :)
      }
    }
  }
  ));
}

