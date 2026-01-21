function X_smooth = sg_smooth(X,N,F)
% INPUT :  X - 待处理数据矩阵：（mxn），m条光谱，n个波长             
%          N - 拟合次数
%          F - 窗口参数，必须为奇数;
% OUTPUT: X_smooth  - S-G卷积平滑矩阵：（mxn）

[c,r]=size(X);
[~,g]=sgolay(N,F);
Halfwin=((F+1)/2)-1;

for k=1:c
y=X(k,:);
    for n=(F+1)/2:r-(F+1)/2+1
    X_smooth(k,n)=dot(g(:,1),y(n-Halfwin:n+Halfwin));   % 红色是之前没有添加的
    end
end

X_smooth(:,1:(F+1)/2-1)=X(:,1:(F+1)/2-1);
X_smooth(:,r-(F+1)/2+2:r)=X(:,r-(F+1)/2+2:r);