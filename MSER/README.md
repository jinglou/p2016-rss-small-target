## MSER
This code implements the MSER small target detection algorithm in the following paper:

**Jing Lou**, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," ***Multimedia Tools and Applications***, pp. 1-18, 2016. [doi:10.1007/s11042-016-4025-7](http://link.springer.com/article/10.1007/s11042-016-4025-7)

Project page: [http://www.loujing.com/rss-small-target/](http://www.loujing.com/rss-small-target/)

Copyright (C) 2016 [Jing Lou](http://www.loujing.com)

The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.


### Notes

 1. This algorithm utilizes the VLFeat open source library:

	Vedaldi A, Fulkerson B (2008) VLFeat: An open and portable library of computer vision algorithms, version 0.9.19. [http://www.vlfeat.org/](http://www.vlfeat.org/)

 2. The example usage of this code is demonstrated in:
	```matlab
	MSER_DEMO
	```

 3. In each dataset folder, the resulting subfolder `MSER` contains MAT and PNG files. For each input color image, the resulting MAT file is a structure array "MSERs". Each structure element in "MSERs" includes two specified properties of a detected small target: Pixel List and Bounding Box.