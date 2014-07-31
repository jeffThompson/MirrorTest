
// use JPane to set computer ID and name through a dialog box
void setNameAndID() {

  // input fields for ID and name
  JTextField id = new JTextField(4);

  JTextField name = new JTextField(15);
  
  // panel holds the fields in grid
  JPanel panel = new JPanel();
  panel.setLayout(new GridLayout(2,2));
  
  // ID label
  JLabel idLabel = new JLabel();
  idLabel.setText("<html><body><strong>Object ID</strong> (4 digits)</body></html>");
  panel.add(idLabel);
  panel.add(id);
  
  // fancier name label with HTML so we can have a line break
  JLabel nameLabel = new JLabel();
  nameLabel.setText("<html><body><strong>Object name</strong><br>No special characters!</body></html>");
  panel.add(nameLabel);
  panel.add(name);
  
  // display panel, extract ID/name when OK is pressed 
  int result = JOptionPane.showConfirmDialog(null, panel, "Object Information", JOptionPane.OK_CANCEL_OPTION);
  if (result == JOptionPane.OK_OPTION) {
    
    // get text, replace any characters that aren't supposed to be there
    objectID = id.getText();
    
    objectName = name.getText();
    pdfObjectName = name.getText();
    objectName = objectName.replaceAll("[^A-Za-z0-9_\\-]", "");
    
    // if no answer, display dialog again
    if (objectID.equals("") || objectName.equals("")) setNameAndID();
  }
  
  // if canceled then ignore (or could display dialog again)
  else {
    // setNameAndID();
  }
}

