function [Dens,DensFil] = DensityForSTORMImages_EdgeAnalysis(x,y,SR_px)

minX = 0;
maxX = 256;
minY = 0;
maxY = 256;

SR_px = SR_px/160;

coor_bins{1} = minX:SR_px:maxX;
coor_bins{2} = minY:SR_px:maxY;

Dens = hist3([x y],coor_bins);
DensFil = imgaussfilt(Dens,1.5);
end