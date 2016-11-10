%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," 
% Multimedia Tools and Applications, pp. 1-18, 2016. doi:10.1007/s11042-016-4025-7
% Project page: http://www.loujing.com/rss-small-target/
% 
% Copyright (C) 2016 Jing Lou
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function bw = rgn2bw(Rgns,height,width)
%RGB2bw converts the regions RGNS to a binary image BW.

bw = false(height,width);

if ~isempty(Rgns)
	for k = 1:size(Rgns.Regions,2)
		pixellist = Rgns.Regions(k).Props.PixelList;
		for p = 1:size(pixellist,1)
			bw(pixellist(p,2), pixellist(p,1)) = true;
		end
	end
end

end