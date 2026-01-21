function [ax] = auto(x)
% INPUT :  x - 待处理数据矩阵：（mxn），m条光谱，n个波长           
% OUTPUT: ax - 标准化矩阵：（mxn）
[m,~] = size(x);
mx = mean(x);
stdx = std(x);
ax = (x-mx(ones(m,1),:))./stdx(ones(m,1),:);
end