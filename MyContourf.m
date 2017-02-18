function MyContourf(x,y,z,v_all)
% data come from peaks with:
% [x y z] = peaks;
% x=x(:); y=y(:); z=z(:);

figure
hold on
if nargin < 4
	N = 6; % Number of constant line. Default 6.
	h = (max(z) - min(z))/(N+1);
	v_all = min(z)+h:h:max(z)-h;
end
dt=DelaunayTri(x,y);                                         %#ok<*DDELTRI> DelaunayTri class
%triplot(dt);                                                       %print delaunay network
T = dt.Triangulation;                                         
X = dt.X;                                                            % node index
[faceList, elemFace] = FaceTable(T,X);

clear dt
for i=1:length(v_all)
	v = v_all(i);
	coord = OneContour(faceList,elemFace, T,X,z,v);
	for i = 1:length(coord)
		fill(coord{i}.x,coord{i}.y,v);
    end
    colorbar;
end

end
