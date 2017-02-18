function [faceList elemFace] = FaceTable(T,X) 
% the topology of node
% usage: 
%  [faceList elemFace] = FaceTable(T,X)

%  use T and X to create FaceTable
np = size(X,1);                          % line
ne = size(T,1);                          % column

% elem surround point 
esup_p = zeros(np,1);               % value
esup_i = zeros(np,1);                % the start position of the elem array around one point
esup_e = zeros(np,1);               % the end position of the elem array around one point

for ie = 1:ne
	for ip=1:size(T,2)                   %3
		esup_p(T(ie,ip)) = esup_p(T(ie,ip)) + 1;
	end
end
esup_i = cumsum(esup_p)-esup_p+1;
esup_e = esup_i+esup_p-1;

%disp([esup_i esup_e esup_p])

esup = zeros(esup_e(end),1);        % elem number around one point
filled = ones(np,1);                         % start index is 1 not 0

for ie = 1:ne
	for ip=1:size(T,2)
		inode = T(ie,ip);
		esup(esup_i(inode)+filled(inode)-1) = ie;
		filled(inode) = filled(inode)+1;
	end
end

%disp(esup);

%for i=1:np
%disp(esup(esup_i(i):esup_e(i))')
%end

% point surround point
%psup_p = zeros(np,1);
%for ip = 1:np
%	for ie_ind = esup_i(ip):esup_e(ip)
%		ie = esup(ie_ind);
%	end
%end

% elem surround elem
esuel = zeros(ne,3);
filled = ones(ne,1); % start index is 1 not 0
for ie=1:ne
	faceT = reshape(T(ie,[1 2;2 3;3 1]),2,3)'; 
	for iface=1:3
		ip1 = faceT(iface,1);
		ip2 = faceT(iface,2);
		eT1 = esup(esup_i(ip1):esup_e(ip1));
		eT2 = esup(esup_i(ip2):esup_e(ip2));
		e_same = FindSame(eT1,eT2);
		if length(e_same) == 1 
			esuel(ie,filled(ie)) = -1;
			filled(ie) = filled(ie) +1;
		else
			ind = find(e_same ~= ie);
			esuel(ie,filled(ie)) = e_same(ind);
			filled(ie) = filled(ie) +1;
		end
	end
end
%disp(esuel)

% faceList
nface = 0;
for ie=1:ne
    faceT = [1 2;2 3;3 1]; 
    for iface = 1:3
        je = esuel(ie,iface);
        if (je<ie) 
            nface = nface + 1;
            faceList(nface,1) = T(ie,faceT(iface,1));
            faceList(nface,2) = T(ie,faceT(iface,2));
            faceList(nface,3) = ie;
            faceList(nface,4) = je;
            if (je == -1)                                           % is boundary?
                faceList(nface,5) = true;                   
            else
                faceList(nface,5) = false;
            end
        end
    end
end
%%%OneContour(faceList);

%faceList : node1 node2 elem1(Big) elem2(Little) isBoundary

% elemFace
elemFace = zeros(ne,3);
filled = ones(ne,1); % start index is 1 not 0
for i = 1:nface
    ie = faceList(i,[3 4]);
    ie = ie( ie>0); % exclude -1 elem
    for jj=1:length(ie)
        elemFace(ie(jj),filled(ie(jj))) = i; 
    end
    filled(ie) = filled(ie) + 1;
end
end
