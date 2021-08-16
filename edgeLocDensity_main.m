% EDGE ANALYSIS (MAIN)
% Code by Chiara VICARIO 2019-02,modified by Alvaro CASTELLS-GARCIA 2021-07
% Further annotated & Readme file by Victoria NEGUEMBOR 2021-06

% Main function to compute the % of localizations at cell edges (and interior) vs the
% total amount of localizations
% edgeLocDensity_main

close all
clear all 

%% 1) PARAMETERS to ADD

categ = 2;
Folder = ('C:\Users\');
CategLabels = {'Condition1','Condition2'};
%Colors = [0.6314    0.0039    0.7569;  0 0 1 ]; %% magenta, %% blue
Colors = colormap(jet(2));

SR_px = 20; % nm
NPx_edge = 50; %% number of SR_px around the edge, adjust if desired
nmperpx = 160; % original pixel size in nm (change depending on microscope) 160 for 100x Nikon NSTORM
sigma = 1.5; % Sigma value of Gaussian, adjust if desired
CombinePerc = {};


for m = 1:categ
    
    % load the .bin files of DNA localizations for each category
    Data{1,m} = uipickfiles;
    
end

for m = 1:categ
%    
    D = Data{1,m};
    
    for k =1:length(D)
       
        % Load Locs coordinates 
        Coo = Insight3(D{1,k});
        Coo = Coo.data;
        Coo = Coo(:,3:4);
%         Coo = Coo(Coo(:,12)==2));

    % Compute the Edge localization percentage
        [INSIDE{m,k}, EDGE{m,k}, FULL{m,k}]= edgeLocDensity(Coo,SR_px,NPx_edge,sigma,nmperpx);
        
    % General info on the .bin file (OPTIONAL)
        [Density{m,k},LocsTot{m,k},Area{m,k}] = InfoData(Coo,SR_px,nmperpx,sigma);
        
        

    end
%     

    % Combine all data 
    INSIDE_all{m,1} = vertcat(INSIDE{m,:});    
    EDGE_all{m,1} = vertcat(EDGE{m,:});
    FULL_all{m,1} = vertcat(FULL{m,:});

    % Mean
    INSIDE_ave{m,1}(1,:) = mean(INSIDE_all{m,1});    
    EDGE_ave{m,1}(1,:) = mean(EDGE_all{m,1});
    FULL_ave{m,1}(1,:) = mean(FULL_all{m,1});
    
    % STD
    INSIDE_ave{m,1}(2,:) = std(INSIDE_all{m,1});    
    EDGE_ave{m,1}(2,:) = std(EDGE_all{m,1});
    FULL_ave{m,1}(2,:) = std(FULL_all{m,1});
    
    % SE
    INSIDE_ave{m,1}(3,:) = std(INSIDE_all{m,1})./sqrt(size(INSIDE_all{m,1},1));    
    EDGE_ave{m,1}(3,:) = std(EDGE_all{m,1})./sqrt(size(EDGE_all{m,1},1));
    FULL_ave{m,1}(3,:) = std(FULL_all{m,1})./sqrt(size(FULL_all{m,1},1));
    
    Density_all{m,1} = vertcat(Density{m,:});
    Area_all{m,1}= vertcat(Area{m,:});
    Locs_all{m,1}= vertcat(LocsTot{m,:});
%   
    CombinePerc = vertcat(CombinePerc,{INSIDE_all{m,1}(:,3)});  
    
end


% Generate density map (OPTIONAL)

 
 densrend = input('Do Density rendering (Y/N)>','s');

if densrend=='Y'; 
  
for m = 1:categ
    data = Data{1,m};
    for k = 1:length(data)
        D = Insight3(data{1,k});
        xy = D.data(:,3:4);
        [Dens, DensFil] = Density11(xy(:,1),xy(:,2),nmperpx,SR_px,sigma);
                 [Dens,DensFil] = DensityForSTORMImages_EdgeAnalysis(D.data(:,1),D.data(:,2),10);
        figure(),
        %subplot(4,5,k)
        imagesc(DensFil)
        hold on
        colormap(jet)
        axis image
        caxis([0 5])
    end
end

 else
end

% generate matrix of results
IN = horzcat(INSIDE_ave{1,1},INSIDE_ave{2,1});
EDGE = horzcat(EDGE_ave{1,1},EDGE_ave{2,1});

datafortable = [];
for v = 1:categ
    Datatotranspose = Data {1,v}';
    datafortable = vertcat (datafortable, Datatotranspose);
end


datafortable2 = cell2table(datafortable);
datafortable2.Properties.VariableNames  = {'Path_cell'};


EDGE_all_fortable = array2table(vertcat(EDGE_all{:,1}));
EDGE_all_fortable.Properties.VariableNames  = {'Edge_Density_Average','Edge_Density_Median','Percentage_localizations_edge'};


INSIDE_all_fortable = array2table(vertcat(INSIDE_all{:,1}));
INSIDE_all_fortable.Properties.VariableNames  = {'Inside_Density_Average','Inside_Density_Median','Percentage_localizations_Inside'};

FULL_all_fortable = array2table(vertcat(FULL_all{:,1}));
FULL_all_fortable.Properties.VariableNames  = {'Full_Density_Average','Full_Density_Median'};

 Tabletosave = horzcat(datafortable2,EDGE_all_fortable,INSIDE_all_fortable,FULL_all_fortable);
 
 writetable(Tabletosave,strcat(Folder,'\EDGE_analysis_results.xlsx'));
