%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," 
% Multimedia Tools and Applications, pp. 1-18, 2016. doi:10.1007/s11042-016-4025-7
%
% Project page: http://www.loujing.com/rss-small-target/
% 
% Copyright (C) 2016 Jing Lou
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function isSameCluster = belong(region1,region2)
%BELONG checks whether the regions REGION1 and REGION2 are belonged to the
% same cluster based on the center distance.

isSameCluster = false;

center1 = region1.Props.Centroid;
width1  = region1.Props.BoundingBox(3);
height1 = region1.Props.BoundingBox(4);

center2 = region2.Props.Centroid;
width2  = region2.Props.BoundingBox(3);
height2 = region2.Props.BoundingBox(4);

widthMin = min(width1,width2);
heightMin = min(height1,height2);

dist = (center2(1)-center1(1))^2 + (center2(2)-center1(2))^2;
if dist <= widthMin^2/4 + heightMin^2/4
	isSameCluster = true;
end

end