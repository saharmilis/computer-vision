import cv2
import sys
import numpy

imageName = "image.png";
maskName = "mask.png"
windowName = 'Select a rectangle, press q when finished';

initialX = 0;
initialY = 0;
finalX = 0;
finalY = 0;
drawing = False;
drawn = False;

def draw(event, x, y, flags, param):
    global drawn,drawing,initialX,initialY,finalX,finalY

    if event == cv2.EVENT_LBUTTONDOWN:
        print "down"
        print x;
        print y;
        print "";
        initialX = finalX = x;
        initialY = finalY = y;
        drawing = True;
        drawn = False;

    if event == cv2.EVENT_MOUSEMOVE and drawing:
        print "on"
        print x;
        print y;
        print "";
        finalX = x;
        finalY = y;

    if event == cv2.EVENT_LBUTTONUP and drawing:
        print "up"
        print x;
        print y;
        print "";
        finalX = x;
        finalY = y;
        drawing = False;
        drawn = True;




cap = cv2.VideoCapture(0)

# set width & height
cap.set(3, 800); # w
cap.set(4, 600); # h

# make sure camara open
if not cap.isOpened():
    cap.open();

# set up window for desplay and mouse EVENT
cv2.namedWindow(windowName);
cv2.setMouseCallback(windowName, draw);

# display video
while (cap.isOpened()):
    ret, frame = cap.read();

    # cv2.line(frame, (0, 0), (511, 511), (255, 255, 255), 5)
    cv2.rectangle(frame, (initialX, initialY), (finalX, finalY), (255, 255, 255), 5);

    if drawn :
        if initialX > finalX:
            temp = initialX;
            initialX = finalX;
            finalX = temp;
        if initialY > finalY :
            temp  = initialY;
            initialY = finalY;
            finalY = temp;

        for h in range(0,848) :
            for w in range(0,480):
                if not ((initialY < w < finalY) and (initialX < h < finalX)) :
                    # print(str(h) + " ||| " + str(w))
                    frame[w,h] = 0;

    cv2.imshow(windowName, frame);
    cv2.moveWindow(windowName, 1, 1);

    # waiting for user to notify close
    k = cv2.waitKey(1) & 0xFF
    if k == ord('q'): # press q to quit
        cv2.destroyAllWindows()
        break



# close video
cap.release()
cv2.destroyAllWindows()
