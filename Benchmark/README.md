<pre>
------------------------------------------------------------------------------------------------------
This benchmark database is used for small target detection in the following paper: 

Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and 
Saliency in a Color Image," Multimedia Tools and Applications, pp. 1-18, 2016. 
doi:10.1007/s11042-016-4025-7

Project page: http://www.loujing.com/rss-small-target/

Copyright (C) 2016 Jing Lou

The usage of this data and code is restricted for non-profit research usage only and using of the code is 
at the user's risk.
------------------------------------------------------------------------------------------------------

NOTES:
1. This benchmark database contains three datasets (totally 1,093 color images). Each dataset folder 
includes the following subfolders:
	a) [Image]			input color images
	b) [GT]			ground truth
	c) [MSER], [RSS]	two example models for reference

2. This benchmark database provides the pixel-wise ground truth for each input image. In [GT], each MAT file 
contains four properties of the ground truth target: Area, Boundary, Bounding Box, and Pixel List.

3. You can use the MATLAB script "Evaluation.m" to evaluate your detection results.  Please read the help text
in the script for more details.

</pre>