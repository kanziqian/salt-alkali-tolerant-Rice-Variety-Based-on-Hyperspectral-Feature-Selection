function [mcx] = center(x)
% INPUT :  x - 待处理数据矩阵：（mxn），m条光谱，n个波长           
% OUTPUT: mcx - 均值中心化矩阵：（mxn）
[m,~] = size(x);
mx    = mean(x);
mcx   = (x-mx(ones(m,1),:));
end