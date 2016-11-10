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

function [FillRate,AspectRatio] = merge(Regions,ClusterNo)
%MERGE merges the candidate REGIONS having the same CLUSTERNO (i.e., in the
% same cluster) in each segmented image, and returns the FILL RATE, and the
% ASPECT RATIO of this cluster.

FillRate = zeros(size(Regions,2),ClusterNo);
AspectRatio = zeros(size(Regions,2),ClusterNo);

tmpArea   = zeros(size(Regions,2),ClusterNo);
tmpLeft   = zeros(size(Regions,2),ClusterNo);
tmpTop    = zeros(size(Regions,2),ClusterNo);
tmpRight  = zeros(size(Regions,2),ClusterNo);
tmpBottom = zeros(size(Regions,2),ClusterNo);
tmpWidth  = zeros(size(Regions,2),ClusterNo);
tmpHeight = zeros(size(Regions,2),ClusterNo);
for m = 1:size(Regions,2)
	for n = 1:size(Regions(m).Regions,2)
		tmpClusterNo = Regions(m).Regions(n).ClusterNo;
		tmpArea(m,tmpClusterNo) = tmpArea(m,tmpClusterNo)+Regions(m).Regions(n).Props.FilledArea;
		if tmpLeft(m,tmpClusterNo)==0
			tmpLeft(m,tmpClusterNo) = Regions(m).Regions(n).Props.BoundingBox(1);
		elseif tmpLeft(m,tmpClusterNo) > Regions(m).Regions(n).Props.BoundingBox(1)
			tmpLeft(m,tmpClusterNo) = Regions(m).Regions(n).Props.BoundingBox(1);
		end
		if tmpTop(m,tmpClusterNo)==0
			tmpTop(m,tmpClusterNo) = Regions(m).Regions(n).Props.BoundingBox(2);
		elseif tmpTop(m,tmpClusterNo) > Regions(m).Regions(n).Props.BoundingBox(2)
			tmpTop(m,tmpClusterNo) = Regions(m).Regions(n).Props.BoundingBox(2);
		end
		if tmpRight(m,tmpClusterNo)==0
			tmpRight(m,tmpClusterNo) = Regions(m).Regions(n).Props.BoundingBox(1)+Regions(m).Regions(n).Props.BoundingBox(3);
		elseif tmpRight(m,tmpClusterNo) < Regions(m).Regions(n).Props.BoundingBox(1)+Regions(m).Regions(n).Props.BoundingBox(3)
			tmpRight(m,tmpClusterNo) = Regions(m).Regions(n).Props.BoundingBox(1)+Regions(m).Regions(n).Props.BoundingBox(3);
		end
		if tmpBottom(m,tmpClusterNo)==0
			tmpBottom(m,tmpClusterNo) = Regions(m).Regions(n).Props.BoundingBox(2)+Regions(m).Regions(n).Props.BoundingBox(4);
		elseif tmpBottom(m,tmpClusterNo) < Regions(m).Regions(n).Props.BoundingBox(2)+Regions(m).Regions(n).Props.BoundingBox(4)
			tmpBottom(m,tmpClusterNo) = Regions(m).Regions(n).Props.BoundingBox(2)+Regions(m).Regions(n).Props.BoundingBox(4);
		end
	end

	for n = 1:ClusterNo
		tmpWidth(m,n) = tmpRight(m,n)-tmpLeft(m,n);
		tmpHeight(m,n) = tmpBottom(m,n)-tmpTop(m,n);
		if tmpWidth(m,n)*tmpHeight(m,n)~=0
			FillRate(m,n) = tmpArea(m,n)/(tmpWidth(m,n)*tmpHeight(m,n));
		end
		if tmpHeight(m,n)~=0
			AspectRatio(m,n) = tmpWidth(m,n)/tmpHeight(m,n);
		end
	end
end

end