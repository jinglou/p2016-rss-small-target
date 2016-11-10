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

function rgb = labeltarget(rgb, targets)
%LABELTARGET labels TARGETS in a color image RGB and returns the labelled image.

if ~isempty(targets)
	for k = 1:targets.RegionNums
		pixellist   = targets.Regions(k).Props.PixelList;
		boundingbox = targets.Regions(k).Props.BoundingBox;
		for p = 1:size(pixellist,1)
			rgb(pixellist(p,2),pixellist(p,1),1) = 0;
			rgb(pixellist(p,2),pixellist(p,1),2) = 255;
			rgb(pixellist(p,2),pixellist(p,1),3) = 0;
		end
		rgb = drawrect(rgb, boundingbox, [255 0 0], 2);
	end
end
end



function rgb = drawrect(rgb, rect, color, linewidth)
%DRAWRECT draws a RECT in a color image RGB with the corresponding COLOR
% and LINE WIDTH.

x1 = rect(1);
x1e = x1-linewidth+1;
if x1e<1; x1e = 1; end

y1 = rect(2);
y1e = y1-linewidth+1;
if y1e<1; y1e = 1; end

x2 = rect(1)+rect(3)-1;
x2e = x2+linewidth-1;
if x2e>size(rgb,2); x2e = size(rgb,2); end

y2 = rect(2)+rect(4)-1;
y2e = y2+linewidth-1;
if y2e>size(rgb,1); y2e = size(rgb,1); end

% top
for p = y1e:y1
	rgb(p, x1e:x2e, 1) = color(1);
	rgb(p, x1e:x2e, 2) = color(2);
	rgb(p, x1e:x2e, 3) = color(3);
end

% down
for p = y2:y2e
	rgb(p, x1e:x2e, 1) = color(1);
	rgb(p, x1e:x2e, 2) = color(2);
	rgb(p, x1e:x2e, 3) = color(3);
end

% left
for p = x1e:x1
	rgb(y1:y2, p, 1) = color(1);
	rgb(y1:y2, p, 2) = color(2);
	rgb(y1:y2, p, 3) = color(3);
end

% right
for p = x2:x2e
	rgb(y1:y2, p, 1) = color(1);
	rgb(y1:y2, p, 2) = color(2);
	rgb(y1:y2, p, 3) = color(3);
end
end
