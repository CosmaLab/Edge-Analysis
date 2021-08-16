% EDGE ANALYSIS (ACCESSORY FUNCTION)
% Code by Chiara VICARIO 2019-02
% Further annotated & Readme file by Victoria NEGUEMBOR 2021-06

% Accessory function to compute the % of localizations at cell edges (and interior) vs the
% total amount of localizations


function [INSIDE, EDGE, FULL]= edgeLocDensity(xy,SR_px,NPx_edge,sigma,nmperpx)
 
% input is xy = localizations coordinates
% SR_px for the rendering 
% Npx_edge = number of the SR_px used for the edge
 
% output = 
% INSIDE = [inside_density_average,inside_density_median,percLoc_inside];
% EDGE = [edge_density_average,edge_density_median,percLoc_edge];
% FULL = [full_density_average ,full_density_median];
 
 
%NPx_edge =30;
%SR_px = 20;
%nmperpx = 160;
%sigma = 1.5;
[Dens, DensFil] = Density11(xy(:,1),xy(:,2),nmperpx,SR_px,sigma);
figure()
hold on
%figure
subplot(2,3,1), 
imagesc(Dens), axis image
title('Dens')
 
% %% Binarize and segment the nuclear Area from the DensFil image
BW = im2bw(DensFil,0);
BW = imclose(BW,[1,1;1,1]);
BW = imfill(BW,'holes');
BW = bwareafilt(BW,1);
%figure(1)
subplot(2,3,2), 
imagesc(BW), axis image
title('BW')

SE = strel('disk',NPx_edge,0);
EdgeBW = imdilate(bwperim(BW),SE);
%figure
%figure(1)
subplot(2,3,3), 
imagesc(EdgeBW), axis image
title('EdgeBW')

[~,L] = bwboundaries(EdgeBW);
%figure(1)
subplot(2,3,4), 
imagesc(L), axis image
title('L')
hold off
% figure, imagesc(L), axis image, title('L')
 
 
% Define the spaces (in, out, all)
% Find values and quantify
 
% INSIDE
insideM = (L==2);
inside = Dens.*insideM;
inside_area = numel(find(insideM~=0)).*SR_px.*SR_px;  % area is nm2!! 
inside_values = sum(inside(:));
inside_density_average = inside_values./inside_area; % Density is in n of Locs per nm2
inside_density_median = median(inside(inside~=0))./(SR_px.*SR_px);% Density is in n of Locs per nm2
% figure(1), subplot(1,3,1), imagesc(inside), axis image, title('inside'), caxis([0 20])
 
% EDGE
 
edgeM = (L==1);
edge = Dens.*edgeM;
edge_area = numel(find(edgeM~=0)).*SR_px.*SR_px;  % area is nm2!! 
edge_values = sum(edge(:));
edge_density_average = edge_values./edge_area; % Density is in n of Locs per nm2
edge_density_median = median(edge(edge~=0))./(SR_px.*SR_px);% Density is in n of Locs per nm2
% figure(1), subplot(1,3,2), imagesc(edge), axis image, title('edge'), caxis([0 20])
%
% ALL
fullM = imbinarize(L,0);
full = Dens.*fullM;
full_area = numel(find(fullM~=0)).*SR_px.*SR_px;  % area is nm2!! 
full_values = sum(full(:));
full_density_average = full_values./full_area; % Density is in n of Locs per nm2
full_density_median = median(full(full~=0))./(SR_px.*SR_px);% Density is in n of Locs per nm2
% figure(1), subplot(1,3,3), imagesc(full), axis image, title('full'), caxis([0 20])
 
percLoc_inside = 100*inside_values/full_values;
percLoc_edge = 100*edge_values/full_values;
 
INSIDE = [inside_density_average,inside_density_median,percLoc_inside];
EDGE = [edge_density_average,edge_density_median,percLoc_edge];
FULL = [full_density_average ,full_density_median];
 
end

