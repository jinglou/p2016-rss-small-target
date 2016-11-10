%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Jing Lou, Wei Zhu, Huan Wang, Mingwu Ren, "Small Target Detection Combining Regional Stability and Saliency in a Color Image," 
% Multimedia Tools and Applications, pp. 1-18, 2016. doi:10.1007/s11042-016-4025-7
% Project page: http://www.loujing.com/rss-small-target/
% 
% Copyright (C) 2016 Jing Lou
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SalMap = RSS_Saliency(img, param)
%RSS_SALIENCY generates the saliency map SALMAP of a color image IMG by exploiting the parameter PARAM. 

lab = rgb2lab(img);
[height,width,~] = size(img);

sigma = ceil(min(height,width)/param.sigma_s);
hsize = 3*sigma;

l = double(lab(:,:,1));  lomega = imfilter(l,fspecial('gaussian',hsize,sigma),'symmetric','conv');
a = double(lab(:,:,2));  aomega = imfilter(a,fspecial('gaussian',hsize,sigma),'symmetric','conv');
b = double(lab(:,:,3));  bomega = imfilter(b,fspecial('gaussian',hsize,sigma),'symmetric','conv');

SalMap = (l-double(lomega)).^2 + (a-double(aomega)).^2 + (b-double(bomega)).^2;
SalMap = im2uint8(mat2gray(SalMap));

end