function [Xsnv] = SNV(X)
% INPUT :  x  - 待处理数据矩阵：（mxn），m条光谱，n个波长            
% OUTPUT: Xsnv  - 标准正态变量变换矩阵：（mxn）

[~,n]=size(X);
rmean=mean(X,2);
dr=X-repmat(rmean,1,n);
Xsnv=dr./repmat(sqrt(sum(dr.^2,2)/(n-1)),1,n);