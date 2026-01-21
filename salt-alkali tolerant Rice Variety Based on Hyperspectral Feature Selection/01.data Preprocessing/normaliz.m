function [nx] = normaliz(x)
% INPUT :  x - 待处理数据矩阵：（mxn），m条光谱，n个波长             
% OUTPUT: nx - 规范化矩阵：（mxn）
[m,~]=size(x);
nx=x;
nm=zeros(m,1);
for i = 1:m
nm(i)=norm(nx(i,:));
nx(i,:)=nx(i,:)/nm(i);
end