function masked_vector = mf_vector_mask_zero(vector,criterion_length)
% masked_vector = mf_vector_mask_zero(vector,criterion_length)
% mask continuous non-zero values in a vector as zero, if their length is < criterion_length

%-------------------------------------------------------------------------
% mfeeg is free and open source,under GPL
% Hope it will be useful to you but without any warranty
% You can use,distribute,modify it.
% Welcome to find bugs,suggest improvements, and discuss with the author
%
% Xiang Wu     https://sites.google.com/site/rwfwuwx/Home/mfeeg
%              rwfwuwx@gmail.com         
%-------------------------------------------------------------------------

if nargin~=2
    disp('mf_vector_mask_zero requires 2 input arguments!')
	return
end

masked_vector=vector;
non_zero_area=[]; % each row, start point and point number, of a non-zero area

allow_start_point=1;
%start_point=[];
point_number=0;
for ii=1:length(vector)
    if vector(ii)~=0 & allow_start_point
        start_point=ii;
        point_number=point_number+1;
        allow_start_point=0;
    elseif vector(ii)~=0 & allow_start_point==0
        point_number=point_number+1;
    elseif vector(ii)==0 & allow_start_point==0
        tmp_area=[start_point,point_number];
        non_zero_area=[non_zero_area;tmp_area];
        allow_start_point=1;
        point_number=0;
     else %     if vector(ii)==0 & allow_start_point==1
     end
end

%non_zero_area
if ~isempty(non_zero_area)
    remove_area_index = find(non_zero_area(:,2)<criterion_length);
    if ~isempty(remove_area_index)
        for ii=1:length(remove_area_index)
            tmp=non_zero_area(remove_area_index(ii),:);
            tmp_area=tmp(1):(tmp(1)+tmp(2)-1);
            masked_vector(tmp_area)=0;
        end
    end
end
