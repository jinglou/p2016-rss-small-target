## MSER
This code implements the MSER small target detection algorithm in the following paper:

 - **Jing Lou**, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," ***Multimedia Tools and Applications***, vol. 76, no. 13, pp. 14781-14798, 2017. [doi:10.1007/s11042-016-4025-7](http://link.springer.com/article/10.1007/s11042-016-4025-7 "doi:10.1007/s11042-016-4025-7")

 - Project page: [http://www.loujing.com/rss-small-target/](http://www.loujing.com/rss-small-target/)
 - You can directly download the zipped file of the MATLAB code: [MSER.zip](https://raw.githubusercontent.com/jinglou/p2016-rss-small-target/master/MSER.zip).

Copyright (C) 2016 [Jing Lou (楼竞)](http://www.loujing.com)

The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.


### Notes

 1. This algorithm utilizes the VLFeat open source library:

	Vedaldi A, Fulkerson B (2008) VLFeat: An open and portable library of computer vision algorithms, version 0.9.19. [http://www.vlfeat.org/](http://www.vlfeat.org/)

 2. Please unzip `vlfeat-0.9.19.zip` and run the algorithm by the command:
	```matlab
		MSER_DEMO
	```

 3. In each dataset folder, the resulting subfolder `MSER` contains MAT and PNG files. For each input color image, the resulting MAT file is a structure array "MSERs". Each structure element in "MSERs" includes two specified properties of a detected small target: Pixel List and Bounding Box.
