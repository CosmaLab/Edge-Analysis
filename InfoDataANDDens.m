function [Dens,Density,LocsTot,Area] = InfoDataANDDens(xy,SR_px)

% INPUTs:
% -the xy coordinates of DNA localizations for the .bin file (therefore in px)
% -the SR_px is the super resolved pixel size 

% OUTPUTs:
% -matrix and image of the density map
% -the area of the nucleus in nm^2
% -the total number of localizations
% -density of localizations in locs/nm^2 

% density map
[Dens,DensF] = DensMapFig1(xy(:,1),xy(:,2),SR_px);

% % Convexhull for the area
[~,Area] = convhull(xy(:,1)*160,xy(:,2)*160); % coordinates in nm, Area in  nm2
LocsTot = size(xy,1);     % number of locs
Density = LocsTot./Area;  % in locs/nm^2

end