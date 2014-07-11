

'''
TEST CASCADE
Jeff Thompson | 2014 (adapted from some 2012 code) | www.jeffreythompson.org

A simple utility to test our newly-made cascade file; we load
an image and should get a bounding-box around it!

'''

# import library - MUST use cv2 if using opencv_traincascade
import cv2 as cv

def rgb(r,g,b):				# OpenCV wants colors as BGR not RGB - weird
	return (b,g,r)			# so flip the color order for something more natural

def get_key():
	key = cv.waitKey(5)
	if key == 27:
		cv.destroyAllWindows()
		exit()

def get_frame():
	_, img = capture.read()
	cv.flip(img, 1)
	return img

webcam_id = 0
stroke_color = rgb(255,0,0)			# outline color (using rgb function)
stroke_weight = 1					# thickness of outline
window_name = 'Object Detection'	# appears onscreen

# setup for capture and cascade file
cv.namedWindow(window_name, cv.CV_WINDOW_AUTOSIZE)
capture = cv.VideoCapture(webcam_id)
cascade = cv.CascadeClassifier('../TrainingTest/iPhoneSingle/Cascade_100Neg_10Stages_95Accept.xml')

while True:
	get_key()
	img = get_frame()
	
	# preprocessing - not needed but suggested by:
	# http://www.bytefish.de/wiki/opencv/object_detection
	gray_img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)		# convert to grayscale
	gray_img = cv.equalizeHist(gray_img)				# normalize bright, increase contrast

	# detect objects, return as list of rectangles (x,y of upper-left corner, width/height)
	# detection is done on the preprocessed grayscale copy created in previous step
	rects = cascade.detectMultiScale(gray_img)
	img - cv.cvtColor(gray_img, cv.COLOR_GRAY2BGR)		# convert back to color so we can see rectangles
	for x,y, width,height in rects:
		cv.rectangle(img, (x,y), (x+width, y+height), stroke_color, stroke_weight)

	# display result!
	cv.imshow(window_name, img)
