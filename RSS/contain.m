%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," 
% Multimedia Tools and Applications, vol. 76, no. 13, pp. 14781-14798, 2017. doi:10.1007/s11042-016-4025-7
% 
% Project page: http://www.loujing.com/rss-small-target/
% 
% Copyright (C) 2016 Jing Lou
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [isContain,idx] = contain(region1,region2)
%CONTAIN checks whether REGION1 is enclosed in REGION2 or not by exploiting
% their bounding boxes, and returns the corresponding ID (1 or 2) of the bigger one.

isContain = false;

area1 = region1.Props.BoundingBox(3)*region1.Props.BoundingBox(4);
area2 = region2.Props.BoundingBox(3)*region2.Props.BoundingBox(4);
if area1 < area2
	regionSmall = region1;
	regionBig = region2;
	idx = 2;
else
	regionSmall = region2;
	regionBig = region1;
	idx = 1;
end

rectSmall   = regionSmall.Props.BoundingBox;
leftSmall   = rectSmall(1);
topSmall    = rectSmall(2);
widthSmall  = rectSmall(3);
heightSmall = rectSmall(4);

rectBig   = regionBig.Props.BoundingBox;
leftBig   = rectBig(1);
topBig    = rectBig(2);
widthBig  = rectBig(3);
heightBig = rectBig(4);

if leftSmall>=leftBig && topSmall>=topBig ...
		&& leftSmall+widthSmall<=leftBig+widthBig ...
		&& topSmall+heightSmall<=topBig+heightBig ...
		&& ~(leftSmall==leftBig && topSmall==topBig && leftSmall+widthSmall==leftBig+widthBig && topSmall+heightSmall==topBig+heightBig)
	isContain = true;
end

end