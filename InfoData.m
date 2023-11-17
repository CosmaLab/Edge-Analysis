function [Density,LocsTot,Area] = InfoData(xy,SR_px,nmperpx,sigma)

% input are the xy coordinates of DNA localizations for the .bin file (therefore in px)
% outputs are three values with info about the density of localizations in locs/nm^2, 
% the total number of localizations and the area of the nucleus in nm^2

% ATT!!!! the values depends on: 
%1) the filters used to generate the nuclear area mask
%2) on the SR_px !!!!

[Dens, ~] = DensityMap(xy(:,1),xy(:,2),nmperpx,SR_px,sigma);

%%% Binarize and quantify the nuclear Area of Filled 
BW = im2bw(Dens,0);
BW = imclose(BW,[1 1;1 1]);
BW = imfill(BW,'holes');

%%% Uncomment for Figure visualization of B/W mask
%figure()
%imshow(BW)
%title('B/W Nuclear Mask')

%%% Comment/Uncomment the area according to the unit Area desired
Area = numel(find(BW>0));  % SR_px^2
%Area = Area.*SR_px.*SR_px; % converted in nm^2

LocsTot = size(xy,1);
Density = LocsTot./Area;  % in loc/Area (SR_px^2 or nm^2)


end