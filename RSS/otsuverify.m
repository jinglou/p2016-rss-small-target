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

function PoStaRgns = otsuverify(gray, param, PoStaRgns, region, ClusterNo)
%OTSUVERIFY computes the Otsu's thresholding value of the subimage in a
% gray-scale image GRAY. The subimage is extracted from GRAY by exploiting
% the bounding box of the maximally stable region REGION. If REGION
% satisfies the constraint of area variation, it is added to POSTARNGS with its properties.

[height,width] = size(gray);

isClusterMatch = false;
if region.ClusterNo == ClusterNo
	rect    = region.Props.BoundingBox;
	rleft   = uint16(rect(1));
	rtop    = uint16(rect(2));
	rwidth  = uint16(rect(3));
	rheight = uint16(rect(4));
	rright  = uint16(min(rleft+rwidth,width));
	rbottom = uint16(min(rtop+rheight,height));
	cropimg = gray(rtop:rbottom, rleft:rright);		% subimage
	isClusterMatch = true;
end

if isClusterMatch == true
	% segment using Otsu's method
	OtsuThresh = graythresh(cropimg);
	[hasRgnLow,bwLow] = existrgn(cropimg, OtsuThresh-param.delta/255/2);
	[hasRgnUpp,bwUpp] = existrgn(cropimg, OtsuThresh+param.delta/255/2);
	
	% measure area variation \Delta_r
	if hasRgnLow==true && hasRgnUpp==true
		[areaLow,~,~] = maxrgn(bwLow);
		[areaUpp,~,~] = maxrgn(bwUpp);
		if areaLow>=param.size && abs(areaLow-areaUpp)<=param.Delta_r*areaUpp ...
				|| areaLow<param.size && abs(areaLow-areaUpp)<=param.Delta_r*param.size
			PoStaRgns.RegionNums = PoStaRgns.RegionNums+1;
			tmpNums = PoStaRgns.RegionNums;
			[~,bw] = existrgn(cropimg,OtsuThresh);
			[~,boundary,pixellist] = maxrgn(bw);
			PoStaRgns.Regions(tmpNums).ClusterNo = ClusterNo;
			
			% Boundary
			for p = 1:size(boundary,1)
				tmpx = boundary(p,2)+rleft-1;
				if tmpx<1
					tmpx = 1;
				elseif tmpx>width
					tmpx = width;
				end
				tmpy = boundary(p,1)+rtop-1;
				if tmpy<1
					tmpy = 1;
				elseif tmpy>height
					tmpy = height;
				end
				boundary(p,2) = tmpx;
				boundary(p,1) = tmpy;
			end
			PoStaRgns.Regions(tmpNums).Props.Boundary = boundary;
			
			% Pixel List
			for p = 1:size(pixellist,1)
				tmpx = pixellist(p,1)+rleft-1;
				if tmpx<1
					tmpx = 1;
				elseif tmpx>width
					tmpx = width;
				end
				tmpy = pixellist(p,2)+rtop-1;
				if tmpy<1
					tmpy = 1;
				elseif tmpy>height
					tmpy = height;
				end
				pixellist(p,1) = tmpx;
				pixellist(p,2) = tmpy;
			end
			PoStaRgns.Regions(tmpNums).Props.PixelList = pixellist;
			
			% Bounding Box
			isFirst = true;
			for p = 1:size(boundary,1)
				if isFirst == true
					minx = boundary(p,2);
					maxx = boundary(p,2);
					miny = boundary(p,1);
					maxy = boundary(p,1);
					isFirst = false;
				else
					if minx > boundary(p,2); minx = boundary(p,2); end
					if maxx < boundary(p,2); maxx = boundary(p,2); end
					if miny > boundary(p,1); miny = boundary(p,1); end
					if maxy < boundary(p,1); maxy = boundary(p,1); end
				end
			end
			if minx>=2; minx=minx-1; end
			if maxx<=width-1; maxx=maxx+1; end
			if miny>=2; miny=miny-1; end
			if maxy<=height-1; maxy=maxy+1; end
			rect = [minx,miny,maxx-minx,maxy-miny];
			PoStaRgns.Regions(tmpNums).Props.BoundingBox = rect;
		end
	end
end

end