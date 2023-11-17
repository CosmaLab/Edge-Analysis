%%% EDGE ANALYSIS (ACCESSORY FUNCTION)
%%% Code by Chiara VICARIO 2019-02
%%% Further annotated & Readme file by Victoria NEGUEMBOR 2021-06
%%% Further modified & annotated by Blanca BRUSCHI and Laura MARTIN 2023-11

%%% Accessory function to compute the % of localizations at nuclear edges (and at nuclear interior) 
%%% vs the total amount of localizations


function [INSIDE, EDGE, FULL]= edgeLocDensity(xy,SR_px,NPx_edge,sigma,nmperpx)
 
% INPUT: 
% xy = localizations coordinates
% SR_px used for the rendering 
% NPx_edge = number of the SR_px used to define the edge
% sigma = sigma value for image smoothing, to identify the nuclear mask
% nmperpx = original pixel size in nm
 
% OUTPUT: 
% INSIDE = [inside_density_average,inside_density_median,percLoc_inside];
% EDGE = [edge_density_average,edge_density_median,percLoc_edge];
% FULL = [full_density_average ,full_density_median];

%%% Rendering of localizations with parameters defined at the beginning of the code (i.e. px size = 20 nm).        
[Dens, DensFil] = DensityMap(xy(:,1),xy(:,2),nmperpx,SR_px,sigma);
figure()
hold on

%%% FIGURE of the density map of the localizations
subplot(2,2,1),
clims = [0 5];  %change values to change limits of density bar
imagesc(Dens, clims), axis image, xlabel('(SR px)'), ylabel('(SR px)')
%colorbar  %OPTIONAL: scale bar of density
title('Density')
 
% %% Binarize and segment the nuclear Area from the DensFil image
BW = im2bw(DensFil,0);
BW = imclose(BW,[1,1;1,1]);
BW = imfill(BW,'holes');
BW = bwareafilt(BW,1);

%%% FIGURE of the mask of the Nuclear area (yellow)
subplot(2,2,2), 
imagesc(BW), axis image,  xlabel('(SR px)'), ylabel('(SR px)')
title('Nuclear mask')

%%% Create a disk-edge around the Nuclear perimeter
%%% NPx_edge is the width of eges on the inside and outside of the border. 
%%% Thus, total width is NPx_edge*2.
SE = strel('disk',NPx_edge,0);       %% define a circular masks of radius NPx_edge around a pixel
%%%                                      0 0 1 1 0
%%%                                      0 1 1 1 0
%%%                                      1 1 1 1 0    %%%example of SE = strel('disk',2,0)
%%%                                      0 1 1 1 0
%%%                                      0 0 1 0 0

%%% Applies SE mask on every pixel of the border of BW
%%% The border becomes thicker both inside AND outside the nucleus
EdgeBW = imdilate(bwperim(BW),SE);

%%% The edge pixels (inside+outside) become 1, the inner pixels become 2.
[~,L] = bwboundaries(EdgeBW);

%%% FIGURE of the mask of nuclear area + FULL EDGE (inside and outside)
%figure()
%imagesc(L), axis image
%title('L')
%hold off
%figure, imagesc(L), axis image, title('L')
 
%% Define the spaces (Edge, Inner, Whole)
% Find n Locs, size areas, and quantify.
 
%%% INSIDE mask
insideM = (L==2);            
inside = Dens.*insideM;
inside_area = numel(find(insideM~=0)).*SR_px.*SR_px;  % area is nm2!! 
inside_values = sum(inside(:));
inside_density_average = inside_values./inside_area; % Density is in n of Locs per nm2
inside_density_median = median(inside(inside~=0))./(SR_px.*SR_px);% Density is in n of Locs per nm2
 
%%% EDGE mask 
%edgeM = (L==1); %%% edge (considering both pixels inside the nuclear masks AND outside).  %Commented by L MARTIN and B BRUSCHI 2023-11
edgeM = (BW - insideM);   %%%% edge -only considering the part of the edge overlapping with the nucleus (not the external empty one). %Added by L MARTIN and B BRUSCHI 2023-11

% FIGURE of the mask of the Edge area (yellow)
subplot(2,2,3), 
imagesc(edgeM), axis image,  xlabel('(SR px)'), ylabel('(SR px)')
title('Edge mask')

edge = Dens.*edgeM;
edge_area = numel(find(edgeM~=0)).*SR_px.*SR_px;  % area is nm2!! 
edge_values = sum(edge(:));
edge_density_average = edge_values./edge_area; % Density is in n of Locs per nm2
edge_density_median = median(edge(edge~=0))./(SR_px.*SR_px);% Density is in n of Locs per nm2

%%% FULL - WHOLE nuclear area
%fullM = imbinarize(L,0); %%nucleus plus external edge. %Commented by L MARTIN and B BRUSCHI 2023-11
fullM = BW; %% nuclear area calculated on the Gaussian blurring of the localizations signal. %Added by L MARTIN and B BRUSCHI 2023-11
full = Dens.*fullM;
full_area = numel(find(fullM~=0)).*SR_px.*SR_px;  % area is nm2!! 
full_values = sum(full(:));
full_density_average = full_values./full_area; % Density is in n of Locs per nm2
full_density_median = median(full(full~=0))./(SR_px.*SR_px);% Density is in n of Locs per nm2

% FIGURE of the mask of the Inner area (yellow) and Edge area (green)
[~,Merge] = bwboundaries(edgeM);   
subplot(2,2,4), 
imagesc(Merge), axis image,  xlabel('(SR px)'), ylabel('(SR px)')
title('Merge')
 
%%% Percentage (%) of Locs in the Edge and in the Inner part.
percLoc_inside = 100*inside_values/full_values;
percLoc_edge = 100*edge_values/full_values;

%%% OUTPUT
INSIDE = [inside_density_average,inside_density_median,percLoc_inside];
EDGE = [edge_density_average,edge_density_median,percLoc_edge];
FULL = [full_density_average ,full_density_median];
 
end

