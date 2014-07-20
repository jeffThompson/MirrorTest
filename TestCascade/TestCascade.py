

'''
TEST CASCADE
Jeff Thompson | 2014 (adapted from some 2012 code) | www.jeffreythompson.org

A little utility to test our newly-made cascade files; test live using
a webcam and we should get a bounding-box around it!

ALSO:
+	numbers 1 (bad), 2 (ok), and 3 (great) rate the image
+	spacebar to load next cascade file (and save rating and settings to log file)
+	escape to quit

TO DO:
+	wow, what a mess.

'''

import cv2 as cv 				# must use cv2 if using opencv_traincascade
import glob, os, re, shutil 	# for other business (gettings files, parsing filenames, etc)

cascade_directory = '../CascadeFiles/'

webcam_id = 	0
stroke_weight = 1						# thickness of outline
window_name =  'Test Cascade Files'		# appears onscreen
output_file =  'Ratings.csv' 			# file to write results

move_cascade_when_done = False					# move the tested cascade folder when rated?
rated_dir =    			 '../RATED_CASCADES'	# where to move, if specified


rating = 1 		# how is this cascade?


def rgb(r,g,b):				# OpenCV wants colors as BGR not RGB - weird
	return (b,g,r)			# so flip the color order for something more natural


def get_key():
	key = cv.waitKey(5)

	global which_cascade, rating

	# spacebar for next cascade file
	if key == 32:
		if (which_cascade + 1 < len(cascades)):
			
			# print old rating
			print '\n' + '- rating:       ' + str(rating)
			with open(output_file, 'a') as output:
				output.write(str(rating) + ',' + (',').join(settings) + '\n')

			# move to rated folder (let's us pick back up in the event of a crash)
			if move_cascade_when_done:
				parent_dir = os.path.abspath(os.path.join(cascades[which_cascade], os.pardir))
				shutil.move(parent_dir, rated_dir + '/' + cascades[which_cascade].split('/')[-2] + '/')

 			# load next cascade
			which_cascade += 1
			load_cascade()
		else:
			# move to rated folder (let's us pick back up in the event of a crash), then quit ('cause we're done!)
			if move_cascade_when_done:
				parent_dir = os.path.abspath(os.path.join(cascades[which_cascade], os.pardir))
				shutil.move(parent_dir, rated_dir + '/' + cascades[which_cascade].split('/')[-2] + '/')
			quit()

	# 1-5 to rate
	elif key >= ord('1') and key <= ord('3'):
		rating = chr(key)

	# esc to quit
	elif key == 27:
		quit()


def load_cascade():
	global cascade, settings, rating

	print '\n' + ('- ' * 5) + '\n\n' + 'LOADING NEW CASCADE FILE...'
	path = cascades[which_cascade]
	print path

	cascade = cv.CascadeClassifier(path)
	settings = get_cascade_settings(path)
	print_settings(settings)
	rating = 1


# CascadeOutput_10Stages-10Pos-100Neg-0.8AccceptRate-32W-32H
def get_cascade_settings(path):
	settings = path.split('/')[-2]
	stages = re.search(r'([0-9]+)Stages', settings).group(1)
	pos = re.search(r'([0-9]+)Pos', settings).group(1)
	neg = re.search(r'([0-9]+)Neg', settings).group(1)
	accept = re.search(r'(0\.[0-9]+)AcceptRate', settings).group(1)
	w = re.search(r'([0-9]+)W', settings).group(1)
	h = re.search(r'([0-9]+)H', settings).group(1)
	return [ stages, pos, neg, accept, w, h ]


def print_settings(s):
	print ''
	print '- stages:      ', s[0]
	print '- # pos:       ', s[1]
	print '- # neg:       ', s[2]
	print '- accept rate: ', s[3]
	print '- dims:        ', s[4], 'x', s[5]


def get_frame():
	_, img = capture.read()
	cv.flip(img, 1, img)		# flip so R=R, L=L
	return img


def quit():
	print '\n' + ('- ' * 5) + '\n\n'
	cv.destroyAllWindows()
	exit()


# get list of cascade files
print 'LOADING CASCADE FILES...'
cascade_dirs = glob.glob(cascade_directory + '*')
cascades = []
for directory in cascade_dirs:
	path = directory + '/' + 'cascade.xml'
	if os.path.exists(path):
		cascades.append(path)
which_cascade = 0
print '- found', len(cascades), 'cascade files...'


# load cascade file
load_cascade()


# setup for capture from webcam
cv.namedWindow(window_name, cv.CV_WINDOW_AUTOSIZE)
capture = cv.VideoCapture(webcam_id)


# create log file, if it doesn't exist yet
if not os.path.exists(output_file):
	with open(output_file, 'w') as output:
		output.write('rating,stages,pos,neg,accept_rate,w,h' + '\n')

# otherwise, add a blank line to separate from previous readings
else:
	with open(output_file, 'a') as output:
		output.write(',,,,,,' + '\n')


# create 'RATED' folder too, if we're moving cascades
if move_cascade_when_done and not os.path.exists(rated_dir):
	os.mkdir(rated_dir)


# run!
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
	stroke_color = rgb(255,0,0)							# outline color (using rgb function)
	img - cv.cvtColor(gray_img, cv.COLOR_GRAY2BGR)		# convert back to color so we can see rectangles
	for x,y, width,height in rects:
		cv.rectangle(img, (x,y), (x+width, y+height), stroke_color, stroke_weight)

	# show current cascade and rating onscreen
	cv.putText(img, str(which_cascade+1) + '/' + str(len(cascades)) + ': ' + cascades[which_cascade], (20,40), cv.FONT_HERSHEY_SIMPLEX, 0.5, rgb(255,255,255))
	cv.putText(img, str(rating), (20,130), cv.FONT_HERSHEY_SIMPLEX, 3, rgb(255,255,255))

	# display result!
	cv.imshow(window_name, img)
