#!/bin/sh

gst-launch-1.0 v4l2src device=/dev/video0 ! capsfilter caps="video/x-raw,width=640,height=480,framerate=30/1" ! decodebin ! videoconvert ! autovideosink


