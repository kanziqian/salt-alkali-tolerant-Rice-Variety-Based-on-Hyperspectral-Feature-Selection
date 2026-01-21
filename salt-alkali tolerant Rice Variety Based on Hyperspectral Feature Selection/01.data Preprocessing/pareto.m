function [spectra_pareto] = pareto(x)
% INPUT :  x - 待处理数据矩阵：（mxn），m条光谱，n个波长           
% OUTPUT: spectra_pareto - 尺度化矩阵：（mxn）
[m,n]  = size(x);
x_mean = mean(x); 
dX     = x - repmat(x_mean,m,1);
spectra_pareto = dX./sqrt(repmat(sqrt(sum(dX.^2,2)/n),1,n));
end