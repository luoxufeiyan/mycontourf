#MyContourf
draw contour line like contourf() by using delaunay triangulation.

##Usage
`function MyContourf(x,y,z,v_all)`
v_all is a optional input.

e.g: `[x y z] = peaks;`

##Sample input

* sample func
 x = (rand(100000,1)*2-1)*100;
 y = (rand(100000,1)*2-1)*100; 
%[X,Y]=meshgrid(x,y);    
 z=sin(sqrt(x.^2+y.^2))./sqrt(x.^2+y.^2);
%Z=sin(sqrt(X.^2+Y.^2))./sqrt(X.^2+Y.^2);   
%mesh(X,Y,Z);

* Gauss func
 x = (rand(5000,1)*2-1)*3;
 y = (rand(5000,1)*2-1)*3;
 for i=1:5000
     z(i) = exp(-(x(i)^2+y(i)^2));
 end

##License
GPL