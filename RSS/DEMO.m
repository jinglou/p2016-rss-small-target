%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code implements the RSS small target detection model in the following paper:
% 
% Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," 
% Multimedia Tools and Applications, pp. 1-18, 2016. doi:10.1007/s11042-016-4025-7
%
% Project page: http://www.loujing.com/rss-small-target/
% 
% Copyright (C) 2016 Jing Lou
% 
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

%% Dataset
data = 'Data1';				% Data1, Data2, or Data3

%% Parameters
param.size     = 100;		% small target size
param.delta    = 16;		% sample step \delta
param.Delta_r  = 0.2;		% area variation \Delta_r
param.sigma_s  = 16;		% filter parameter \sigma_s
% target area (fixed value)
param.minarea  = 4;			% pixels
param.maxarea  = 0.2;		% ratio

%% RSS
% make folders
if exist([data,'\StaMaps'], 'dir') ~= 7		% stability maps (.png)
	system(['md ',data,'\StaMaps']);
end
if exist([data,'\SalMaps'], 'dir') ~= 7		% saliency maps (.png)
	system(['md ',data,'\SalMaps']);
end
if exist([data,'\RSS'], 'dir') ~= 7			% detected small targets (.mat and .png)
	system(['md ',data,'\RSS']);
end

imgs = dir([data,'\Image\*.png']);
for k = 1:length(imgs)
	fprintf('  %3d/%3d : ', k, length(imgs));
	
	tic;
	
	rgb = imread([data,'\Image\',int2str(k),'.png']);
	if ndims(rgb) == 2		% for gray-scale image
		rgb = repmat(rgb, [1 1 3]);
	end
	gray = rgb2gray(rgb);
	
	% (1) extract stability regions, and generate stability map
	StabilityRegions = RSS_Stability(gray, param);
	StabilityMap = rgn2bw(StabilityRegions,size(gray,1),size(gray,2));
	imwrite(StabilityMap, [data,'\StaMaps\',int2str(k),'_Sta.png']);
	
	% (2) detect saliency, and generate saliency map
	SaliencyMap = RSS_Saliency(rgb, param);
	imwrite(SaliencyMap, [data,'\SalMaps\',int2str(k),'_Sal.png']);
	
	% (3) obtain the final detection result by combining stability map and saliency map
	Targets = RSS(StabilityRegions, StabilityMap, SaliencyMap);
	save([data,'\RSS\',int2str(k),'_RSS.mat'],'Targets');
	TargetsMap = rgn2bw(Targets,size(gray,1),size(gray,2));
	imwrite(TargetsMap,[data,'\RSS\',int2str(k),'_RSS.png']);
	
	toc;
	
	% [Optional] show RSS detection result in real time
% 	figure(1);
% 	subplot(221),imshow(rgb);
% 	subplot(222),imshow(labeltarget(rgb,Targets));
% 	subplot(223),imshow(StabilityMap);
% 	subplot(224),imshow(SaliencyMap);
% 	pause(0.01);

end