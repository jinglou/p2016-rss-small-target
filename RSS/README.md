# RSS Notebooks

This code implements the RSS small target detection model in the following paper:

**Jing Lou**, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," ***Multimedia Tools and Applications***, pp. 1-18, 2016. [doi:10.1007/s11042-016-4025-7](http://link.springer.com/article/10.1007/s11042-016-4025-7)

Project page: [http://www.loujing.com/rss-small-target/](http://www.loujing.com/rss-small-target/)

Copyright (C) 2016 [Jing Lou](http://www.loujing.com)

The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.


## Notes

 1. The example usage of the code is demonstrated in:
	```matlab
		>>DEMO
	```

 2. There are three resulting folders in each dataset folder:
	 1. | `aaa`        | bbb           |
	 1. `StaMaps`		stability maps
	 2. `SalMaps`		saliency maps
	 3. `RSS`			detection results, including .mat and .png

 3. For each input color image, the resulting MAT file is a structure array "Targets" with the following fields:
	 1. `RegionNums`	the number of detected small targets
	 2. `Regions`		a structure array with the regional properties of all detected small targets
		 1. `ClusterNo`	the Cluster No. of each target
		 2. `Props`		the regional properties of each target, including Boundary, Pixel List, and Bounding Box