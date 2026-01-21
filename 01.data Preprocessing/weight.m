function [sum] = weight(i,t,m,n,s)
sum=0;
for k=0:n
sum=sum+(2*k+1)*(genfact(2*m,k)/genfact(2*m+k+1,k+1))*...
grampoly(i,m,k,0)*grampoly(t,m,k,s);
end