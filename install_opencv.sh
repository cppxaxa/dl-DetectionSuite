#!/bin/sh
if [ -n "$(ls -A $HOME/opencv/build)" ];
 then
 	# We're using a cached version of our OpenCV build
<<<<<<< HEAD
 	cd $HOME/opencv/build;#
=======
 	cd $HOME/opencv/build;
>>>>>>> 04ac539d58e6089b4298ad8070536178f9d80d28
	sudo make install
 else
 	# No OpenCV cache – clone and make the files
 	rm -rf $HOME/opencv;
	wget https://github.com/opencv/opencv/archive/3.4.2.zip
	unzip -q 3.4.2.zip -d $HOME/
	mv $HOME/opencv-3.4.2 $HOME/opencv
	cd $HOME/opencv
	mkdir build && cd build
	cmake ..
	make -j4
	sudo make install
 fi

