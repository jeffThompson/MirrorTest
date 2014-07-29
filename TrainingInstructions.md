
TRAINING CASCADE FILES
=====
**Jeff Thompson + 2014 + [www.jeffreythompson.org](www.jeffreythompson.org)**

These instructions (currently rough working notes) are for creating OpenCV object recognition "cascade" files.

Generously supported by a grant/residency from [Impakt](http://www.impakt.nl) and developed while in residence in Utrecht, Netherlands.

- - -

**CONTENTS**  
1. Requirements  
2. Installing OpenCV  
3. Gathering positive images  
4. Crop and clean up  
5. "No black pixels", remove background  
6. Creating a collection file  
7. Gathering negative images  
8. Automated training  
9. Test the results

- - -

1. REQUIREMENTS
====

+	A digital camera (even a crappy cellphone camera will work ok)
+	Updated version of Python
+	Homebrew installed (see [http://brew.sh](http://brew.sh) for instructions - it's very easy!)
+	OpenCV2 (cv2) library (see the next step for instructions)

Optional:  

+	Camera with video capability (shooting video is much faster and easier, in many cases)  
+	FFMPEG library (once Hombebrew is installed, just type 'brew install ffmpeg') for splitting video frames

- - -

2. INSTALLING OPENCV
====

These instructions assume you're working on a Mac or Unix-based machine. Sorry to other users, though these should work with a little tweaking!

** NOTE! The cv2 install will likely BREAK your OpenCV installation for use with Processing. Processing will work normally, but you won't be able to use OpenCV with it. You have been warned! **

1. Install the OpenCV library using Homebrew and these instructions:
[http://www.jeffreythompson.org/blog/2013/08/22/update-installing-opencv-on-mac-mountain-lion](http://www.jeffreythompson.org/blog/2013/08/22/update-installing-opencv-on-mac-mountain-lion)

2. Verify your installation by typing `opencv` into the Terminal. You can also check the other necessary commands: `opencv_createsamples` and `opencv_traincascade`.

If they work, you should be all set! Problems? Please post a question in the blog post above.

- - -

3. GATHERING POSITIVE IMAGES
====

To "train" our system, we need images of the object. While professional OpenCV training can used 5000 or more images (!), we can likely get away with 10-20, or even just 1, depending on the object (like a logo).

Setting up for your shoot is important: select a plain backdrop and, if possible, build a small "photo slope" to eliminate distracting elements. This isn't necessary, but will make things easier in later steps.

Images do not need to be high-res - in fact, they should be in JPG or PNG format and under 1MB when you are finished. You will want a small F-stop for a good depth of field, if your camera allows.

Shoot your object from lots of angles, or shoot a video moving around and extract the frames using `ffmpeg`:

`ffmpeg -i MacbookProVideo.mp4 -r 24 -s 940x540 -f image2 MacbookProFrames/%08d.png`

60 seconds of video = 1,440 images - more than enough!

Give yourself plenty of room around the object, since every selected object must be the same aspect ratio.

- - -

4. RESIZE AND GRAYSCALE (optional)
====

If necessary, you may need to resize your images so they aren't too large. Anything between 640x480 and 1920x1080 seems to work just fine, and is well under the 1MB max size.

While you could use Photoshop to batch resize the images and convert them to grayscale, you can also use `ImageMagick`, a command-line tool that is really fast and powerful. To resize an entire folder:

```
cd folderofimages
mogrify -path outputdir -type Grayscale -resize 960x540 *.(inputextension)
```

This will save the images at the specified resolution in another folder, and convert them to grayscale (required for OpenCV). To overwite existing files just skip the `-path` part.

- - -

5. NO BLACK PIXELS, REMOVE BACKGROUND (optional)
====

If you want to use the `-bcolor` when training your cascade so that OpenCV ignores the background of your images, you will need to complete these steps.

First, run the 'No Black Pixels' Processing sketch. This goes through all images in a selected directory and changes any completely black pixels (rgb(0,0,0)) to slightly lighter (rgb(1,1,1)).

Once complete, open your images in Photoshop (or your editor of choice) and paint all background areas completely black (rgb(0,0,0)). These areas will be ignored by OpenCV when training, so that it doesn't see the background as part of your object.

How accurate do you need to be? Not at all. OpenCV will ultimately reduce your images to very small (like, 24px across) so you can do this rather quickly.

This is a rather tedious step, but may give you higher-quality results. You might be thinking "whey can't I shoot against a green screen and automate this process?". Sadly, OpenCV is grayscale only, so this doesn't help!

- - -

6. CREATING A COLLECTION FILE
====

OpenCV will require a text file listing all of your positive images along with a "bounding box" of the object. There are lots of manual ways to do this, but I've written a Processing app to make it more pleasurable. Open the 'Create Collection File' sketch. It only draws square bounding boxes, ensuring your aspect ratio will always be the same.

a. Open the folder where the images are stored  
b. Click-and-drag to define the boundaries of the object in the photograph; hold down `alt` to draw the box from the center  
c. Hit spacebar to save the selection; arrow keys to jump without saving; enter/return to select the entire image and move on  
d. When done, quit

The app will save a file with all the details of your image as `CollectionFile.txt`.

- - -

7.	GATHERING NEGATIVE IMAGES
====

Along with our positive images, we need images of **not** our object. This can be anything! Generally, we need at least twice as many negative images as positive, though you may want more (more images = longer processing time and slower detection later). These images should also be larger in size than the boundaries of our positive images selected in the last step.

There are sets of negative images available online (you can batch download them using `wget`), of just shoot lots of pictures.

For this project, I used images from [http://tutorial-haartraining.googlecode.com/svn/trunk/data/negatives/](http://tutorial-haartraining.googlecode.com/svn/trunk/data/negatives/) and ran this command:

`wget -r -P /save/location -A jpeg,jpg,bmp,gif,png http://tutorial-haartraining.googlecode.com/svn/trunk/data/negatives/`

`/save/location` should be the path you want to save the images to on your computer.

Once you have your images in one folder, you need to create a text file listing them. Too tedious to do by hand!

```
cd folderofnegimages
ls -d -1 $PWD/** > bg.txt
```

This gets full path to the images, which is helpful in later steps.

- - -

8.	AUTOMATED TRAINING
====

This is it! With all of our resources assembled, there are actually a few more steps but I've automated them using a Python script. You can set lists of settings to try and the script does the rest. Here's what happens "under the hood":

1. New collection and negative image lists are created, if you want to use fewer images.  
2. A "vector" file is created. This essentially is a binary file with all the positive images, cropped to the appropriate size. Here is the command used, which you could also run in the Terminal:

`opencv_createsamples -info collection.txt -bg negativeImages.txt -vec positiveVectorFile.vec -num numBoundingBoxes -w 32 -h 24`
       
`-info` and `-bg` are the collection file and negative image files created above
`-vec` is the name of vector file to be created in this step (can by anything)
`-num` is number of objects defined in the collection file - problems will occur if this number is higher than the actual count
`-w` and `-h` are the width and height to apply to samples (note the aspect ratio must be the same as used in the collection file); 24x24 is common for face tracking, but you can try with other values too
`-bgcolor` and `bgthresh` are optional and are used to set a "clear" background; values are grayscale from 0-255
`-show`	is also optional and will display the images when done; use any key to advance the images and escape to exit
`-nosym` is another option if you want to specify that your object is *not* symmetrical in both the X and Y directions (OpenCV assumes it is)

You can also just use one image and have `create_samples` apply random transformations and place the image on top of your negative images! This is great for logos and fixed objects where you want lots of angles. For more details, see: [http://docs.opencv.org/doc/user_guide/ug_traincascade.html](http://docs.opencv.org/doc/user_guide/ug_traincascade.html)

3. The training is run – this can take a few seconds or minutes, or hours or days!
4. The resulting cascade file is spit out when the training is done.  
5. The script repeats all combinations of the settings.

- - -

9.	TEST THE RESULTS
====

asdf

- - -



