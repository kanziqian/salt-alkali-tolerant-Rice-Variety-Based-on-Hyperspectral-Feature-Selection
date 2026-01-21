function [xdetrend] = detrend(x)
% INPUT :  x - 待处理数据矩阵：（mxn），m条光谱，n个波长           
% OUTPUT: xdetrend - 去趋势处理矩阵：（mxn）
[m,n] = size(x);
var = (1:n);
for i = 1:m
  p = polyfit(var,x(i,:),2);     % 将二阶多项式拟合到每个频谱的基线
  xdetrend(i,:) = x(i,:)-(p(1)*var.^2+p(2)*var+p(3));     % 将此函数减去光谱的任何光谱数据
end