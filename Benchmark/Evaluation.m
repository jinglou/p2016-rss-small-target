%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code is used for evaluating small target detection models in the following paper: 
%
% Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image,"
% Multimedia Tools and Applications, vol. 76, no. 13, pp. 14781-14798, 2017. doi:10.1007/s11042-016-4025-7
%
% Project page: http://www.loujing.com/rss-small-target/
% 
% Copyright (C) 2016 Jing Lou
%
% The usage of this code is restricted for non-profit research usage only and using of the code is at the user's risk.
% ------------------------------------------------------------------------------------------------------
%
% Notes:
%   1. To use this code for evaluation, the pixel-level binary images (PNG format) should be provided. 
%   You can create a new subfolder in each dataset folder and put your detection results in your subfolder, 
%   then add your model name to the cell "Models" of this code.
%   Two example subfolders ([MSER] and [RSS]) are provided in the dataset folders for reference.
%
%   2. To compute the Precision score for each image, the number of all detected targets should be provided. 
%   This code use the "regionprops" function of Image Processing Toolbox to automatically calculate it from the binary image.
%
%   3. This code generates the following evaluation results:
%      a) In each dataset folder, the resulting file "PRF_XXXX.mat" contains the values of Precision, Recall and F-measure 
%         for each image.
%      b) In the root directory, the resulting file "Stat.mat" includes the average values of Precision, Recall and F-measure 
%         for each model. 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

%% Models
Models = {'MSER','RSS'};				% *** ADD YOUR MODEL HERE ***

%% Datasets
Datasets = {'Data1','Data2','Data3'};

%% Compute Precision, Recall and F-Measure for each model
for datano = 1:length(Datasets)
	imgnums = length(dir([Datasets{datano},'\GT\*.mat']));  % the number of images
	PRF = zeros(imgnums,3);					% Precision, Recall, F-measure
	
	for modelno = 1:length(Models)
		fprintf(['======= ',Datasets{datano},' / ',Models{modelno},' =======\n']);
		
		for imgno = 1:imgnums
			fprintf('.');
			if ~mod(imgno,50); fprintf('%d\n',imgno); end
			
			% ground truth image
			G = imread([Datasets{datano},'\GT\',int2str(imgno),'_GT.png']);
			
			% ground truth targets
			load([Datasets{datano},'\GT\',int2str(imgno),'_GT.mat']);
			
			% binary mask image
			M = imread([Datasets{datano},'\',Models{modelno},'\',int2str(imgno),'_',Models{modelno},'.png']);
			if ndims(M) == 3				% 24-bit image
				M = rgb2gray(M);
			end
			if ~islogical(M)				% 8-bit image
				M = im2bw(M);
			end
			% detected targets
			targets = regionprops(M,'BoundingBox');
			
			% compute Precision, Recall
			if ~isempty(GT)
				if isempty(targets)
					PRF(imgno,1) = 0;					% Precision
					PRF(imgno,2) = 0;					% Recall
				else
					tmp = double(length(find(G.*M==1))>=size(GT.PixelList,1)*0.5);
					PRF(imgno,1) = tmp/length(targets);	% Precision
					PRF(imgno,2) = tmp/length(GT);		% Recall
				end;
			else
				PRF(imgno,1) = isempty(targets);		% Precision
				PRF(imgno,2) = isempty(targets);		% Recall
			end
			
			% compute F-measure
			if PRF(imgno,1)~=0 || PRF(imgno,2)~=0
				PRF(imgno,3) = 2*PRF(imgno,1)*PRF(imgno,2)/(PRF(imgno,1)+PRF(imgno,2));
			else
				PRF(imgno,3) = 0;
			end
		end
		
		% save to the model subfolder
		save([Datasets{datano},'\PRF_',Models{modelno},'.mat'], 'PRF');
		clear PRF;
		
		fprintf('\n');
	end
	fprintf('\n\n');
end


%% Statistical comparison on each dataset
Stat{1,1} = 'Model';
Stat{1,2} = 'Dataset';
Stat{1,3} = 'Precision';
Stat{1,4} = 'Recall';
Stat{1,5} = 'F-measure';
for modelno = 1:length(Models)	
	
	% on each dataset
	PRF_Model = zeros(3,3);			% average values of Precision, Recall, F-measure
	for datano = 1:length(Datasets)
		if exist([Datasets{datano},'\PRF_',Models{modelno},'.mat'], 'file') == 2
			load([Datasets{datano},'\PRF_',Models{modelno},'.mat']);
		end
		PRF_Model(datano,1) = mean(PRF(:,1));
		PRF_Model(datano,2) = mean(PRF(:,2));
		PRF_Model(datano,3) = mean(PRF(:,3));
		Stat{(modelno-1)*length(Datasets)+datano+1,1} = Models{modelno};
		Stat{(modelno-1)*length(Datasets)+datano+1,2} = Datasets{datano};
		Stat{(modelno-1)*length(Datasets)+datano+1,3} = PRF_Model(datano,1);
		Stat{(modelno-1)*length(Datasets)+datano+1,4} = PRF_Model(datano,2);
		Stat{(modelno-1)*length(Datasets)+datano+1,5} = PRF_Model(datano,3);
		clear PRF;
	end
	
	% on all datasets
	Stat{length(Models)*length(Datasets)+modelno+1,1} = Models{modelno};
	Stat{length(Models)*length(Datasets)+modelno+1,2} = 'Average';
	tmp = mean(PRF_Model);
	Stat{length(Models)*length(Datasets)+modelno+1,3} = tmp(1);
	Stat{length(Models)*length(Datasets)+modelno+1,4} = tmp(2);
	Stat{length(Models)*length(Datasets)+modelno+1,5} = tmp(3);
end

% save
save('Stat.mat', 'Stat');		% mat
% xlswrite('Stat.xlsx', Stat);	% [Optional] xlsx
