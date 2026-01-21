function [gf] = genfact(a,b)
gf=1;
for i=(a-b+1):a
  gf=gf*i;
end