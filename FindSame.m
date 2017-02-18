function [out] = FindSame( v1, v2)
% find the same element in v1 and v2
out =[];
for i=1:length(v1)
	ind = find(v1(i) == v2);
	if ~isempty(ind)
		out = [out v1(i)];
	end
end

end
