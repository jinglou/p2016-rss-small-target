%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code implements the MSER small target detection algorithm in the following paper:
%
% Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image,"
% Multimedia Tools and Applications, vol. 76, no. 13, pp. 14781-14798, 2017. doi:10.1007/s11042-016-4025-7
% 
% Project page: http://www.loujing.com/rss-small-target/
%
% Copyright (C) 2016 Jing Lou
%
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

%% VLFeat setup
run('vlfeat-0.9.19\toolbox\vl_setup')

%% Dataset
data = 'Data1';				% Data1, Data2, or Data3

%% Parameters
param.Delta		   = 20;	% \delta
param.MinDiversity = 0.7;	% d_m
param.MaxVariation = 0.7;	% v_m
% target area (fixed value)
param.minarea  = 4;			% pixels
param.maxarea  = 0.2;		% ratio

%% MSER
% make folder
if exist([data,'\MSER'], 'dir') ~= 7			% detected small targets (.mat and .png)
	system(['md ',data,'\MSER']);
end

imgs = dir([data,'\Image\*.png']);
for imgno = 1:length(imgs)
	fprintf('  %3d/%3d : ', imgno, length(imgs));
	
	tic;
	
	rgb = imread([data,'\Image\',int2str(imgno),'.png']);
	if ndims(rgb) == 3
		gray = rgb2gray(rgb);
	end
	
	[r,~] = vl_mser(gray, 'MinDiversity',param.MinDiversity, 'MaxVariation',param.MaxVariation, 'Delta',param.Delta,...
		'BrightOnDark',0,'DarkOnBright',1);
	Regions = {};
	RegNo = 1;
	for rno=r'
		s = vl_erfill(gray,rno) ;
		if length(s) >= param.minarea && length(s)<=numel(gray)*param.maxarea
			[row,col] = ind2sub(size(gray), s);
			if isempty(find(row==1)) && isempty(find(row==size(gray,1))) &&...
					isempty(find(col==1)) && isempty(find(col==size(gray,2)))
				% Pixel List
				Regions{RegNo}.PixelList = [col,row];
				% Bounding Box
				x = min(col);
				y = min(row);
				w = max(col)-x+1;
				h = max(row)-y+1;
				Regions{RegNo}.BoundingBox = [x,y,w,h];
				
				RegNo = RegNo + 1;
			end
		end
	end
	
	% remove the region which is contained in another bigger region
	MSERs = [];
	if ~isempty(Regions)
		RetainedRgns = ones(size(Regions));
		for m = 1:length(Regions)
			bbm = Regions{m}.BoundingBox;
			for n = 1:length(Regions)
				bbn = Regions{n}.BoundingBox;
				if m~=n && bbn(1)>=bbm(1) && bbn(2)>=bbm(2) && ...
						bbn(1)+bbn(3)<=bbm(1)+bbm(3) && bbn(2)+bbn(4)<=bbm(2)+bbm(4)
					RetainedRgns(n) = 0;
				end
			end
		end
		
		RegNo = 1;
		for k = 1:length(Regions)
			if RetainedRgns(k) == 1
				MSERs(RegNo).PixelList = Regions{k}.PixelList;
				MSERs(RegNo).BoundingBox = Regions{k}.BoundingBox;
				RegNo = RegNo + 1;
			end
		end
	end
	
	% save
	bin = false(size(gray));
	if ~isempty(MSERs)
		for k = 1:length(MSERs)
			pixellist   = MSERs(k).PixelList;
			for p = 1:size(pixellist,1)
				bin(pixellist(p,2),pixellist(p,1),1) = true;
			end
		end
	end
	save([data,'\MSER\',int2str(imgno),'_MSER.mat'],'MSERs');
	imwrite(bin,[data,'\MSER\',int2str(imgno),'_MSER.png']);
	
	
	%  [Optional] show MSER detection result in real time
% 	sRGB = rgb;
% 	if ~isempty(MSERs)
% 		for k = 1:length(MSERs)
% 			% Pixel List
% 			pixellist   = MSERs(k).PixelList;
% 			for p = 1:size(pixellist,1)
% 				sRGB(pixellist(p,2),pixellist(p,1),1) = 0;
% 				sRGB(pixellist(p,2),pixellist(p,1),2) = 255;
% 				sRGB(pixellist(p,2),pixellist(p,1),3) = 0;
% 			end
% 			% Bounding Box
% 			rect = MSERs(k).BoundingBox;
% 			color = [255 0 0];
% 			linewidth = 2;
% 			x1 = rect(1);
% 			x1e = x1-linewidth+1;
% 			if x1e<1; x1e = 1; end
% 			
% 			y1 = rect(2);
% 			y1e = y1-linewidth+1;
% 			if y1e<1; y1e = 1; end
% 			
% 			x2 = rect(1)+rect(3)-1;
% 			x2e = x2+linewidth-1;
% 			if x2e>size(sRGB,2); x2e = size(sRGB,2); end
% 			
% 			y2 = rect(2)+rect(4)-1;
% 			y2e = y2+linewidth-1;
% 			if y2e>size(sRGB,1); y2e = size(sRGB,1); end
% 			
% 			for p = y1e:y1	% top
% 				sRGB(p, x1e:x2e, 1) = color(1);
% 				sRGB(p, x1e:x2e, 2) = color(2);
% 				sRGB(p, x1e:x2e, 3) = color(3);
% 			end
% 			
% 			for p = y2:y2e  % bottom
% 				sRGB(p, x1e:x2e, 1) = color(1);
% 				sRGB(p, x1e:x2e, 2) = color(2);
% 				sRGB(p, x1e:x2e, 3) = color(3);
% 			end
% 			
% 			for p = x1e:x1  % left
% 				sRGB(y1:y2, p, 1) = color(1);
% 				sRGB(y1:y2, p, 2) = color(2);
% 				sRGB(y1:y2, p, 3) = color(3);
% 			end
% 			
% 			for p = x2:x2e  % right
% 				sRGB(y1:y2, p, 1) = color(1);
% 				sRGB(y1:y2, p, 2) = color(2);
% 				sRGB(y1:y2, p, 3) = color(3);
% 			end
% 		end
% 	end
% 	figure(1);
% 	subplot(221),imshow(rgb),title(['# ',int2str(imgno)]);
% 	subplot(222),imshow(bin);
% 	subplot(223),imshow(sRGB);
% 	pause(0.01);
	% ~[Optional]
	
	clear MSERs;
	toc;
end