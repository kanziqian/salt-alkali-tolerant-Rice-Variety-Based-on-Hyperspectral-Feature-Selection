function [Xmsc] = MSC(x)
% INPUT :  x  - 待处理数据矩阵：（mxn），m条光谱，n个波长             
% OUTPUT: Xmsc  - 多元散射校正矩阵：（mxn）

me=mean(x);
[m,n]=size(x);
for i=1:m
p=polyfit(me,x(i,:),1);
Xmsc(i,:)=(x(i,:)-p(2)*ones(1,n))./(p(1)*ones(1,n));
end