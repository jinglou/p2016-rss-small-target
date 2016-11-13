# MSER
This code implements the MSER small target detection algorithm in the following paper:

**Jing Lou**, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," ***Multimedia Tools and Applications***, pp. 1-18, 2016. <a href="http://link.springer.com/article/10.1007/s11042-016-4025-7" target="_blank">doi:10.1007/s11042-016-4025-7</a>

Project page: <a href="http://www.loujing.com/rss-small-target/" target="_blank">http://www.loujing.com/rss-small-target/</a>

Copyright (C) 2016 <a href="http://www.loujing.com" target="_blank">Jing Lou</a>

The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.


## Notes

 1. The algorithm utilizes the VLFeat open source library:

	Vedaldi A, Fulkerson B (2008) VLFeat: An open and portable library of computer vision algorithms, version 0.9.19. [http://www.vlfeat.org/](http://www.vlfeat.org/)

 2. The example usage of the code is demonstrated in 
	```matlab
	>>MSER_DEMO
	```

 3. In each dataset folder, the resulting folder `MSER` includes MAT and PNG files. For each input color image, the resulting MAT file is a structure array `MSERs`. Each structure element includes two specified properties of a detected small target, i.e. Pixel List and Bounding Box.