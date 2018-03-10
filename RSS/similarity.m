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

function SimMeasure = similarity(FillRate,AspectRatio)
%SIMILARITY measures the stability by exploiting FILL RATE and ASPECT RATIO.
%
%   Return
%   ---------
%   SimMeasure:
%		row 1 is the value of most similar Fill Rate, and rows 2,3 are the corresponding Cluster IDs
%		row 4 is the value of most similar Aspect Ratio, and rows 5,6 are the corresponding Cluster IDs
%		row 7 is the minimal value of rows 2,3,5,6
%		row 8 is the maximum value of rows 2,3,5,6

SimMeasure = zeros(10,size(FillRate,2));

for m = 1:size(FillRate,1)-1
	n = m+1;
	for k = 1:size(FillRate,2)
		
		% similarity of Fill Rate
		tmpFillRateMax = max(FillRate(m,k),FillRate(n,k));
		tmpFillRateMin = min(FillRate(m,k),FillRate(n,k));
		if tmpFillRateMin ~= 0
			tmpFillFactorSta = tmpFillRateMax / tmpFillRateMin;
		else
			tmpFillFactorSta = 0;
		end
		if tmpFillFactorSta ~= 0
			if SimMeasure(1,k) == 0
				SimMeasure(1,k) = tmpFillFactorSta;
				SimMeasure(2,k) = m;
				SimMeasure(3,k) = n;
			elseif SimMeasure(1,k) >= tmpFillFactorSta
				SimMeasure(1,k) = tmpFillFactorSta;
				SimMeasure(2,k) = m;
				SimMeasure(3,k) = n;
			end
		end
		
		% similarity of Aspect Ratio
		tmpAspectRatioMax = max(AspectRatio(m,k),AspectRatio(n,k));
		tmpAspectRatioMin = min(AspectRatio(m,k),AspectRatio(n,k));
		if tmpAspectRatioMin ~= 0
			tmpAspectRatioSta = tmpAspectRatioMax / tmpAspectRatioMin;
		else
			tmpAspectRatioSta = 0;
		end
		if tmpAspectRatioSta ~= 0
			if SimMeasure(4,k) == 0
				SimMeasure(4,k) = tmpAspectRatioSta;
				SimMeasure(5,k) = m;
				SimMeasure(6,k) = n;
			elseif SimMeasure(4,k) >= tmpAspectRatioSta
				SimMeasure(4,k) = tmpAspectRatioSta;
				SimMeasure(5,k) = m;
				SimMeasure(6,k) = n;
			end
		end
		if SimMeasure(1,k)~=0 && SimMeasure(4,k)~=0
			SimMeasure(7,k) = min([SimMeasure(2,k), SimMeasure(3,k), SimMeasure(5,k), SimMeasure(6,k)]);
			SimMeasure(8,k) = max([SimMeasure(2,k), SimMeasure(3,k), SimMeasure(5,k), SimMeasure(6,k)]);
		end
	end
end

end