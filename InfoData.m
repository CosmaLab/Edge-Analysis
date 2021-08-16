function [Density,LocsTot,Area] = InfoData(xy,SR_px,nmperpx,sigma)

% input are the xy coordinates of DNA localizations for the .bin file (therefore in px)
% outputs are three values with info about the density of localizations in locs/nm, 
% the total number of localizatoins and the area of the nucleus in nm^2

% ATT!!!! the values depends on 1) the filters used to generate the nuclear
% area mask and 2) on the SR_px !!!!

%nmperpx = 160;
%sigma = 1.5;
[Dens, ~] = Density11(xy(:,1),xy(:,2),nmperpx,SR_px,sigma);
% figure, 
% imagesc(DensFil)

% %% Binarize and quantify the nuclear Area of Filled 
% BW = imbinarize(Dens,0);
BW = im2bw(Dens,0);
% BW = imclose(BW,strel('disk',20,8));
BW = imclose(BW,[1 1;1 1]);
BW = imfill(BW,'holes');

%figure(2)
figure()
imshow(BW)
Area = numel(find(BW>0));

% Area = Area.*SR_px.*SR_px; % converted in nm

LocsTot = size(xy,1);
Density = LocsTot./Area;  % in loc/nm^2


end