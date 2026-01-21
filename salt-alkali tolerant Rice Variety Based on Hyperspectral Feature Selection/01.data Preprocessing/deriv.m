function [dx] = deriv(x,der,window,order)
% INPUT :  x  - 待处理数据矩阵：（mxn），m条光谱，n个波长  
%        der  - 导数的阶数，必须 <= order        
%      window - 窗口数，必须是 >3 的奇数 
%       order - 多项式的顺序，它必须是 <=5 且 <= （window-1）            
% OUTPUT: dx  - 微分函数矩阵：（mxn）
% 一阶导数FD设置der为1，二阶导数SD设置der为2，其他参数一般无需调整

[~,nc] = size(x);
if (nargin<4)
  order = 2;  
  disp(' Polynomial order set to 2')
end
if (nargin<3)  
  window = min(17,floor(nc/2)); 
  disp([' Windows size set to ',num2str(window)]);
end
if (nargin<2)
  disp(' function dx = deriv(x,der)')
end       

m = fix(window/2);   
p = round(window/2);
o = order;

for i=1:window
    i0=i-p;
    for j=1:window
       j0=j-p;
       w(i,j)=weight(i0,j0,m,o,der);
    end
end
yr(:,1:m)=x(:,[1:window])*w(:,1:m);    % First window
for i=1:(nc-2*m)        % Middle
    yr(:,i+m)=x(:,[i:(i+2*m)])*w(:,p);
end
a=nc-2*m;          % Last window
yr(:,(nc-m+1):nc)=x(:,a:nc)*w(:,p+1:window); 
dx=yr;
end