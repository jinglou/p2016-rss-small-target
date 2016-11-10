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

function Targets = RSS(StaRgns, StaMap, SalMap)
%RSS combines the stability map STAMAP and the saliency map SALMAP, and
% returns the detected small TARGETS.

Targets = [];

MasterMap = im2double(StaMap).*im2double(SalMap);
if ~isempty(StaRgns)
	% compute the average saliency of each stable region
	tmpmean = zeros(StaRgns.RegionNums,1);
	assignin('base','StaRngs',StaRgns);
	for k = 1:StaRgns.RegionNums
		pixellist = StaRgns.Regions(k).Props.PixelList;
		idx = sub2ind(size(StaMap), pixellist(:,2), pixellist(:,1));
		tmpmean(k) = mean(MasterMap(idx));
	end
	% the average saliency of all stable regions
	mean_tmpmean = mean(tmpmean);
	
	% targets
	targetNo = 1;
	for k = 1:StaRgns.RegionNums
		if tmpmean(k) >= mean_tmpmean
			Targets.Regions(targetNo) = StaRgns.Regions(k);
			targetNo = targetNo+1;
		end
	end
	Targets.RegionNums = targetNo-1;
end

end