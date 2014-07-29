
// little function to see if we're all done
boolean checkIfDone() {
  
  boolean allSaved = true;    // assume we're done, set false if we hit one that isn't stored
  numStored = 0;              // reset count of # stored
  
  // go through all images, check for non-saved ones
  for (boolean isSaved : stored) {
    if (isSaved == false) allSaved = false;
    else numStored++;
  }
  
  // all true, then we're done! :)
  if (allSaved) {
    done = true;
    return true;
  }
  
  // any not saved? we're not done :(
  else {
    return false;
  }
}
