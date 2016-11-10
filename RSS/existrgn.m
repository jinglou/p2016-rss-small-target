%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," 
% Multimedia Tools and Applications, pp. 1-18, 2016. doi:10.1007/s11042-016-4025-7
% Project page: http://www.loujing.com/rss-small-target/
% 
% Copyright (C) 2016 Jing Lou
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hasRgn,bw] = existrgn(gray,threshold)
%EXISTRGN converts a gray-scale image GRAY to a binary image BW by using THRESHOLD, 
% and checks whether BW contains foreground regions.

bw = im2bw(gray,threshold);
bw = imcomplement(bw);
bw = imfill(bw,'holes');
tmpBoundaries = bwboundaries(bw);

if size(tmpBoundaries,1) >= 1
	hasRgn = true;
else
	hasRgn = false;
end

end