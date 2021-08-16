function [Dens, DensFil] = Density11(x,y,nmperpx,SR_px,sigma)

x = x*nmperpx;
y = y*nmperpx;

minX = min(x); 
maxX = max(x); 
minY = min(y); 
maxY = max(y); 


coor_bins = cell(2,1);


coor_bins{1} = minX:SR_px:maxX;
coor_bins{2} = minY:SR_px:maxY;

Dens = hist3([x y],coor_bins);

DensFil = imgaussfilt(Dens,sigma);



end