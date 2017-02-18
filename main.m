[x y z] = peaks(100);
x=x(:); y=y(:); z=z(:);

%transform matrix if necessary
% x=x';
% y=y';
% z=z';

MyContourf(x,y,z);