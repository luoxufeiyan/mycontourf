function coord = OneContour(faceList,elemFace, T,X,z,v) 
% usage :
% chain = OneContour(faceList,elemFace, T,X,z,v)
nf = size(faceList,1);
isChecked = zeros(nf,1);

chain = {};
for i = 1:nf
    if ( ~isChecked(i) )
        p1 = faceList(i,1);
        p2 = faceList(i,2);
        if( (z(p1) - v)*(z(p2) - v) <=0 ) % ok for this face, then create one chain
            unclosed = 1;
            faceOk = [];
            elemStore = faceList(i,3);
            faceStore = i;
            fp = i;
            isChecked(i) = 1;
            faceOk = [faceOk fp];
            ep = faceList(i,4);
            while ( ep ~= -1 ) % is not boundary  elem
            % find next face
                f_inds = find(elemFace(ep,:) ~= fp);
                p1 = faceList(elemFace(ep,f_inds(1)),1);
                p2 = faceList(elemFace(ep,f_inds(1)),2);
                if( ((z(p1) - v)*(z(p2) - v)) <=0 ) % ok for this line
                    fn = elemFace(ep,f_inds(1));
                else
                    fn = elemFace(ep,f_inds(2));
                end
                faceOk = [faceOk fn];
                isChecked(fn) = 1;
                en_ind = find( faceList(fn,3:4) ~= ep);
                if (length(en_ind) ~= 1) 
                    error( ' faceList is wrong')
                end
                en = faceList(fn,en_ind+2);
                fp = fn;
                if ( fp == faceStore ) 
                    unclosed=0; 
                    break; 
                end % closed loop
                ep = en;
            end
            fp = faceStore;
            ep = elemStore;
            while ( (ep ~= -1) & unclosed ) % is not boundary
            % find next face
                f_inds = find( elemFace(ep,:) ~= fp);
                p1 = faceList(elemFace(ep,f_inds(1)),1);
                p2 = faceList(elemFace(ep,f_inds(1)),2);
                if( ((z(p1) - v)*(z(p2) - v)) <=0 ) % ok for this line
                    fn = elemFace(ep,f_inds(1));
                else
					disp('I am here.')
                    fn = elemFace(ep,f_inds(2));
                end
                faceOk = [fn faceOk]; % insert front
                isChecked(fn) = 1;
                en_ind = find( faceList(fn,3:4) ~= ep);
                if ( length(en_ind) ~= 1) 
                    error(' wrong faceList here');
                end
                en = faceList(fn,en_ind+2);
                fp = fn;
                if ( fp == faceStore ) 
                    unclosed=0; 
                    break; 
                end % closed loop
                ep = en;
            end
            
            % store this chain
            chain = { chain{:}, faceOk };
            %disp(chain);
        end
    end
end

coord = cell(size(chain));
for i=1:length(chain)
    fs = chain{i};
    coord{i}.x = zeros(size(fs));
    coord{i}.y = zeros(size(fs));
    for j=1:length(fs)
        iface = fs(j);
        p1 = faceList(iface,1);
        p2 = faceList(iface,2);
        % interp to 
        %         [z(p1) v z(p2)]
        lambda = (z(p2) - v)/(z(p2)-z(p1));
        coord{i}.x(j) = X(p1,1)*lambda + X(p2,1)*(1-lambda);
        coord{i}.y(j) = X(p1,2)*lambda + X(p2,2)*(1-lambda); 
    end
end

end