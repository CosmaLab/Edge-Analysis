function [Dens,Density,LocsTot,Area] = InfoDataANDDens(xy,SR_px)

% input are the xy coordinates of DNA localizations for the .bin file (therefore in px)
% and SR_px is the super resolved pixel size 

% outputs are: 1) matrix and image of the density map 2)three values with info about the density of localizations in locs/nm, 
% the total number of localizatoins and the area of the nucleus in nm^2

% density map
[Dens,DensF] = DensMapFig1(xy(:,1),xy(:,2),SR_px);

% % Convexhull for the area
[~,Area] = convhull(xy(:,1)*160,xy(:,2)*160); % coordinates in nm, Area in  nm2

LocsTot = size(xy,1);
Density = LocsTot./Area;  % in loc/nm^2

end