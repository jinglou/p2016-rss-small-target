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

function [area,boundary,pixellist] = maxrgn(bw)
%MAXRGN returns the properties (AREA, BOUNDARY, and PIXELLIST) of the
% region which has the longest boundary in the binary image BW.

% Boundary
tmpBoundaries = bwboundaries(bw);
isFirst = true;
for t = 1:size(tmpBoundaries,1)
	if isFirst == true
		boundMax = size(tmpBoundaries{t},1);
		indexMax = t;
		isFirst = false;
	elseif boundMax < size(tmpBoundaries{t},1)
		boundMax = size(tmpBoundaries{t},1);
		indexMax = t;
	end
end
boundary = tmpBoundaries{indexMax};		% Boundary

% regional properties
bw = false(size(bw,1),size(bw,2));
for p = 1:size(boundary,1)
	tmpX = boundary(p,2);
	tmpY = boundary(p,1);
	bw(tmpY,tmpX) = true;
end
Props = regionprops(bw,'FilledArea');
area = Props.FilledArea;				% Area
bw = imfill(bw,'holes');
Props = regionprops(bw,'PixelList');
pixellist = Props.PixelList;			% Pixel List

end