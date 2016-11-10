%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," 
% Multimedia Tools and Applications, pp. 1-18, 2016. doi:10.1007/s11042-016-4025-7
% Project page: http://www.loujing.com/rss-small-target/
% 
% Copyright (C) 2016 Jing Lou
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function HitRgnsFiltered = filterbyhit(Candidate,HitRgnsMask)
%FILTERBYHIT removes the regions from CANDIDATE regions if their HITRNGSMASK equal to 0.

tmpThreshNo = 1;
for m = 1:size(Candidate,2)
	tmpRgnNo = 1;
	needMod = true;
	for n = 1:size(Candidate(m).Regions,2)
		tmpClusterNo = Candidate(m).Regions(n).ClusterNo;
		for k = 1:size(HitRgnsMask,2)
			if k==tmpClusterNo && HitRgnsMask(k)==1
				if needMod == true
					HitRgnsFiltered(tmpThreshNo).Threshold = Candidate(m).Threshold;
					tmpThreshNo = tmpThreshNo+1;
					needMod = false;
				end
				HitRgnsFiltered(tmpThreshNo-1).Regions(tmpRgnNo) = Candidate(m).Regions(n);
				tmpRgnNo = tmpRgnNo+1;
			end
		end
	end
end
end