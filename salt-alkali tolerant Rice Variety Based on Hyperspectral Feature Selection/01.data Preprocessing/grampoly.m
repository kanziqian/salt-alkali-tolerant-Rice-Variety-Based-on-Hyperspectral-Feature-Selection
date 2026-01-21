function [y] = grampoly(i,m,k,s)
if k>0
  r1=grampoly(i,m,k-1,s);
  r2=grampoly(i,m,k-1,s-1);
  r3=grampoly(i,m,k-2,s);
y=((4*k-2)/(k*(2*m-k+1)))*(i*r1+s*r2)-(((k-1)*(2*m+k))/(k*(2*m-k+1)))*r3;
else
  if ((k==0)&&(s==0))
      y=1;
  else
      y=0;
  end
end