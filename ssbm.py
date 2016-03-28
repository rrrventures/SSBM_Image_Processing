__author__ = 'Ilde'
# quita el fondo, deja las puras vidas, ta bueno
import numpy as np
import cv2

cap = cv2.VideoCapture('C:/py/apex.avi')

template = cv2.imread('C:/py/templateprueba.jpg')[:,:,2]
template = template - cv2.erode(template, None)
w, h = template.shape[:2]
threshold = 0.80


while(1):
    ret, frame = cap.read()

    height, width = frame.shape[:2]
    print height, width
    
    frame2 = frame[:,:,2]
    frame2 = frame2 - cv2.erode(frame2, None)

    res = cv2.matchTemplate(frame2,template,cv2.TM_CCORR_NORMED)

    loc = np.where( res >= threshold)

    print loc
    print res.max()

    for pt in zip(*loc[::-1]):
        cv2.rectangle(frame, pt, (pt[0] + w, pt[1] + h), (0,0,255), 2)

    cv2.imshow('frame',frame)
    k = cv2.waitKey(30) & 0xff
    if k == 27:
        break

cap.release()
cv2.destroyAllWindows()
