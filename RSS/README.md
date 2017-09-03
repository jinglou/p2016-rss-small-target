## RSS

This code implements the RSS small target detection model in the following paper:

 - **Jing Lou**, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," ***Multimedia Tools and Applications***, vol. 76, no. 13, pp. 14781-14798, 2017. [doi:10.1007/s11042-016-4025-7](http://link.springer.com/article/10.1007/s11042-016-4025-7 "doi:10.1007/s11042-016-4025-7")

 - Project page: [http://www.loujing.com/rss-small-target/](http://www.loujing.com/rss-small-target/)
 - You can directly download the zipped file of the MATLAB code and data: [RSS.zip](https://raw.githubusercontent.com/jinglou/p2016-rss-small-target/master/RSS.zip).

Copyright (C) 2016 [Jing Lou (楼竞)](http://www.loujing.com)

The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.


### Notes

 1. The example usage of this code is demonstrated in:
	```matlab
		>> DEMO
	```

 2. This code reads the input color image from the subfolder `Image` in each dataset folder, and generates three resulting subfolders:
	 1. `StaMaps`  stability maps
	 2. `SalMaps`  saliency maps
	 3. `RSS`  detection results, including .mat and .png

 3. For each input color image, the resulting MAT file is a structure array "Targets" with the following fields:
	 1. `RegionNums`  the number of the detected small targets
	 2. `Regions`  a structure array with the regional properties of the detected small targets
		 1. `ClusterNo`  the cluster ID of the target
		 2. `Props`  three regional properties of the target: Boundary, Pixel List, and Bounding Box
