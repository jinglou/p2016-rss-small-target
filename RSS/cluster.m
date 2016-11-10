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

function [ClusterRgns, ClusterNo] = cluster(Regions, ClusterNo)
%CLUSTER calls the function BELONG to partition REGIONS into several groups
% by taking account of their spatial relationships, and labels the
% corresponding CLUSTER NOs.

ClusterRgns = Regions;
startInd = 1;
ClusterRgns(1).ClusterNo = ClusterNo;

if size(ClusterRgns,2) == 1		% if only one candidate region
	ClusterNo = ClusterNo+1;
else							% if exist multiple candidate regions
	for m = 2:size(ClusterRgns,2)
		if belong(ClusterRgns(m-1),ClusterRgns(m)) == false
			endInd = m-1;
			for n = startInd:endInd
				ClusterRgns(n).ClusterNo = ClusterNo;
			end
			startInd = m;
			ClusterNo = ClusterNo+1;
		end
	end
	if m == size(ClusterRgns,2) % the last cluster
		for n = startInd:m
			ClusterRgns(n).ClusterNo = ClusterNo;
		end
		ClusterNo = ClusterNo+1;
	end
end

end