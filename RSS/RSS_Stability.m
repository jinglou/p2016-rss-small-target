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

function StabilityRegions = RSS_Stability(gray, param)
%RSS_STABILITY extracts the stable regions STABILITYREGIONS from a gray-scale
% image GRAY by using the parameter PARAM. 

StabilityRegions = [];
[height, width] = size(gray);

% sequential segmentation
ThreshNo = 1;
ClusterNo = 1;	% cluster ID
for thresh = param.delta/2 : param.delta : 256-param.delta/2
	binary = im2bw(gray,thresh/255);
	binary = imcomplement(binary);
	regionno = 1;
	
	AllRgns = regionprops(binary,'FilledArea','BoundingBox','Centroid','PixelList');
	existRgns = false;
	
	% limit target size, and remove non-closed targets
	for k = 1:length(AllRgns)
		if AllRgns(k).FilledArea >= param.minarea && AllRgns(k).FilledArea <= height*width*param.maxarea
			tmpPixelList = AllRgns(k).PixelList;
			isclosed = true;
			if ~isempty(find(tmpPixelList(:,1)==1)) || ~isempty(find(tmpPixelList(:,1)==width)) || ...
					~isempty(find(tmpPixelList(:,2)==1)) || ~isempty(find(tmpPixelList(:,2)==height))
				isclosed = false;
			end
			% candidate regions
			if isclosed == true
				Candidate(ThreshNo).Threshold = thresh;
				Candidate(ThreshNo).Regions(regionno).Props = AllRgns(k);
				Candidate(ThreshNo).Regions(regionno).ClusterNo = 0; % cluster No.
				Candidate(ThreshNo).Regions(regionno).HitCount  = 1; % hit count
				regionno = regionno + 1;
				existRgns = true;
			end
		end
	end
	if existRgns == true
		% clustering in current segmented image
		[Candidate(ThreshNo).Regions,ClusterNo] = cluster(Candidate(ThreshNo).Regions,ClusterNo);
		if ThreshNo >= 2
			for k = 1:size(Candidate(ThreshNo).Regions,2)
				for m = 1:ThreshNo-1
					for n = 1:size(Candidate(m).Regions,2)
						if belong(Candidate(ThreshNo).Regions(k),Candidate(m).Regions(n)) == true
							Candidate(ThreshNo).Regions(k).HitCount = Candidate(ThreshNo).Regions(k).HitCount+1;
							Candidate(m).Regions(n).HitCount = Candidate(m).Regions(n).HitCount+1;
							if Candidate(ThreshNo).Regions(k).Props.FilledArea > Candidate(m).Regions(n).Props.FilledArea
								Candidate(m).Regions(n).ClusterNo = Candidate(ThreshNo).Regions(k).ClusterNo;
							else
								Candidate(ThreshNo).Regions(k).ClusterNo = Candidate(m).Regions(n).ClusterNo;
							end
						end
					end
				end
			end
		end
		ThreshNo = ThreshNo + 1;
	end
end


if exist('Candidate','var') == 1
	ClusterNo = ClusterNo-1;
	
	% compute the average hit count of each candidate region
	avgHitCount = zeros(1,ClusterNo);
	appearCount = zeros(1,ClusterNo);
	for m = 1:size(Candidate,2)
		for n = 1:size(Candidate(m).Regions,2)
			tmpClusterNo = Candidate(m).Regions(n).ClusterNo;
			avgHitCount(tmpClusterNo) = avgHitCount(tmpClusterNo) + Candidate(m).Regions(n).HitCount;
			appearCount(tmpClusterNo) = appearCount(tmpClusterNo)+1;
		end
	end
	for k = 1:ClusterNo
		if appearCount(k)~=0
			avgHitCount(k) = avgHitCount(k)/appearCount(k);
		end
	end
	
	% only retain the candidate region which satisfies hit count >=2
	HitRgnsMask = zeros(1,ClusterNo);
	for k = 1:ClusterNo
		if avgHitCount(k) >= 2
			HitRgnsMask(k) = 1;
		end
	end
	existHitRgn = false;
	if max(HitRgnsMask) ~= 0
		HitRgnsFiltered = filterbyhit(Candidate,HitRgnsMask);
		existHitRgn = true;
	end
	
	% merge the regions of the same cluster, and compute the values of Fill Rate
	% and Aspect Ratio of this cluster
	if existHitRgn == true
		[FillRate,AspectRatio] = merge(HitRgnsFiltered,ClusterNo);
	end
	
	if existHitRgn == true
		% Algorithm 2
		SimMeasure = similarity(FillRate,AspectRatio);
		PoStaRgns = [];				% potential candidate regions
		PoStaRgns.RegionNums = 0;	% the number of all potential candidate regions
		for k = 1:size(SimMeasure,2)
			if SimMeasure(1,k)>=1 && SimMeasure(4,k)>=1
				for p = 1:size(HitRgnsFiltered(SimMeasure(8,k)).Regions,2)
					region = HitRgnsFiltered(SimMeasure(8,k)).Regions(p);
					PoStaRgns = otsuverify(gray, param, PoStaRgns, region, k);
				end
			end
		end
		
		% post-processing
		if PoStaRgns.RegionNums > 0
			% remove the region which is enclosed in another bigger region
			tmpRgnsNeeded = ones(1,size(PoStaRgns.Regions,2));
			for m = 1:size(tmpRgnsNeeded,2)
				tmpNeedContinue = false;
				for n = 1:size(tmpRgnsNeeded,2)
					if m == n
						tmpNeedContinue = true;
						continue;
					end
					[isContain,idx] = contain(PoStaRgns.Regions(m),PoStaRgns.Regions(n));
					if isContain == true
						switch idx
							case 1
								tmpRgnsNeeded(n) = 0;
							case 2
								tmpRgnsNeeded(m) = 0;
						end
					end
				end
				if tmpNeedContinue == true
					continue;
				end
			end
			if PoStaRgns.RegionNums > 1
				for m = 1:size(tmpRgnsNeeded,2)
					if tmpRgnsNeeded(m) == 1
						tmpBoundingBoxM = PoStaRgns.Regions(m).Props.BoundingBox;
						for n = 1:size(tmpRgnsNeeded,2)
							tmpBoundingBoxN = PoStaRgns.Regions(n).Props.BoundingBox;
							if tmpRgnsNeeded(n)==1 && m~=n && sum(tmpBoundingBoxM==tmpBoundingBoxN)==4
								tmpRgnsNeeded(n) = 0;
							end
						end
					end
				end
			end
			
			% detected stable regions
			tmpRgnNo = 1;
			for k = 1:size(tmpRgnsNeeded,2)
				if tmpRgnsNeeded(k) == 1
					StabilityRegions.Regions(tmpRgnNo).Props.Boundary = PoStaRgns.Regions(k).Props.Boundary;
					StabilityRegions.Regions(tmpRgnNo).Props.PixelList = PoStaRgns.Regions(k).Props.PixelList;
					StabilityRegions.Regions(tmpRgnNo).Props.BoundingBox = PoStaRgns.Regions(k).Props.BoundingBox;
					StabilityRegions.Regions(tmpRgnNo).ClusterNo = PoStaRgns.Regions(k).ClusterNo;
					tmpRgnNo = tmpRgnNo+1;
				end
				StabilityRegions.RegionNums = tmpRgnNo-1;	% the number of all stable regions
			end
		end
	end
end