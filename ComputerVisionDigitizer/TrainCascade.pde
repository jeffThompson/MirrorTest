
void createVectorFile() {

  // create vector file
  File vectorDir = new File(objectDir.getAbsolutePath() + "/VectorFiles/");
  if (!vectorDir.exists()) {
    try {
      vectorDir.mkdir();
    }
    catch(Exception e) {
      //
    }
  }
  String[] command = {
    "/usr/local/Cellar/opencv/2.4.5/bin/opencv_createsamples", 
    "-info", outputFile.getAbsolutePath(), 
    "-bg", negativeImageList, 
    "-vec", vectorDir.getAbsolutePath() + "/" + objectID + "-" + objectName + ".vec", 
    "-num", Integer.toString(imageCount), 
    "-w", Integer.toString(imgW), 
    "-h", Integer.toString(imgH)
  };
  boolean success = runUnixCommand(command);
  if (success) vectorFileCreated = true;
  else return;
}


// train cascade!
void trainCascade() {
  File vectorDir = new File(objectDir.getAbsolutePath() + "/VectorFiles/");
  File cascadeDir = new File(objectDir.getAbsolutePath() + "/CascadeFiles/");
  
  if (!cascadeDir.exists()) {
    try {
      cascadeDir.mkdir();
    }
    catch(Exception e) {
      println(e);
    }
  }
  String[] command = new String[] {
    "/usr/local/Cellar/opencv/2.4.5/bin/opencv_traincascade", 
    "-data", cascadeDir.getAbsolutePath(), 
    "-vec", vectorDir.getAbsolutePath() + "/" + objectID + "-" + objectName + ".vec", 
    "-bg", negativeImageList, 
    "-numPos", Integer.toString(imageCount), 
    "-numNeg", Integer.toString(numNeg), 
    "-numStages", Integer.toString(numStages), 
    "-mem", Integer.toString(memoryAllocation), 
    "-maxHitRate", nf(acceptRate, 0, 2), 
    "-w", Integer.toString(imgW), 
    "-h", Integer.toString(imgH),
    "-bgColor", Integer.toString(bgColor),
    "-bgThresh", Integer.toString(bgThresh)
  };
  if (!isSymmetrical) command = append(command, "-noSym");
  
  boolean success = runUnixCommand(command);
  if (success) cascadeTrained = true;
  else return;
  
  copyFile(sketchPath("") + "AboutReadmeText.txt", objectDir.getAbsolutePath() + "/readme.txt");
  copyFile(cascadeDir.getAbsolutePath() + "/cascade.xml", objectDir.getAbsolutePath() + "/" + objectID + "-" + objectName + ".xml");
}

