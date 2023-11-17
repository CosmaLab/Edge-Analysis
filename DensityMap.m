function [Dens, DensFil] = DensityMap(x,y,nmperpx,SR_px,sigma)

% INPUT: 
% xy = localizations coordinates
% nmperpx = original pixel size in nm
% SR_px used for the rendering
% sigma = sigma value for image smoothing, to identify the nuclear mask


%Rescale of coordinates
x = x*nmperpx;
y = y*nmperpx;

%Size of the image
minX = min(x); 
maxX = max(x); 
minY = min(y); 
maxY = max(y); 

%Define binning for histogram
coor_bins = cell(2,1);

coor_bins{1} = minX:SR_px:maxX;
coor_bins{2} = minY:SR_px:maxY;

%%% OUTPUTs

Dens = hist3([x y],coor_bins);

DensFil = imgaussfilt(Dens,sigma);

end