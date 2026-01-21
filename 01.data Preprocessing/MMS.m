function [spectra_MMS] = MMS(x)
% INPUT :  x - 待处理数据矩阵：（mxn），m条光谱，n个波长           
% OUTPUT: spectra_MMS - 离差标准化矩阵：（mxn）
x =x';   % 转置
max_x = max(x);   % 计算每列的最大值
min_x = min(x);   % 计算每列的最小值
spectra_MMS = (x-min_x)./(max_x-min_x);   % 归一化
spectra_MMS=spectra_MMS';
end