%%% EDGE ANALYSIS (MAIN)
%%% Code by Chiara VICARIO 2019-02,modified by Alvaro CASTELLS-GARCIA 2021-07
%%% Further annotated & Readme file by Victoria NEGUEMBOR 2021-06
%%% Further modfied and annotated by Laura MARTIN and Blanca BRUSCHI 2023-11

%%% Main function to compute the % of localizations at nuclear edges vs the total amount of localizations.
%%% It also calculates the localizations density on the edge area (in nm^2).
%%% The same is done for localizations in the inner part of the nucleus. 

%% edgeLocDensity_main

close all
clear all 

%% 1) PARAMETERS to ADD

% Directory folder for OUTPUT file .xlsx
Folder = ('C:\Users');

% Number and names of conditions analysed
categ = 2;
CategLabels = {'Condition1', 'Condition2'};

% Analysis Parameters
SR_px = 20; % nm
NPx_edge = 50; %% number of SR_px around the edge, adjust if desired
nmperpx = 160; % original pixel size in nm (change depending on microscope) 160 for 100x Nikon NSTORM
sigma = 1.5; % Sigma value of Gaussian, adjust if desired
CombinePerc = {};

%%

for m = 1:categ
    
    % LOAD the .bin files of DNA localizations for each category
    Data{1,m} = uipickfiles;
    
end

for m = 1:categ
    
    D = Data{1,m};
    
    %For each .bin list file:
    for k =1:length(D)
       
        % Extract locs coordinates 
        Coo = Insight3(D{1,k});
        Coo = Coo.data;
        Coo = Coo(:,3:4);

        % Compute the Edge localizations percentage and density.
        [INSIDE{m,k}, EDGE{m,k}, FULL{m,k}]= edgeLocDensity(Coo,SR_px,NPx_edge,sigma,nmperpx);
        
        % General info on the .bin file (OPTIONAL)
        % ATT!!! Unit of the Area is define in InfoData (choose SR_px^2 or nm^2)
        % Uncomment inside InfoData to visualize B/W nuclear mask
        [Density{m,k},LocsTot{m,k},Area{m,k}] = InfoData(Coo,SR_px,nmperpx,sigma);
               
    end
     
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

    CombinePerc = vertcat(CombinePerc,{INSIDE_all{m,1}(:,2)});
    
    % General info from InfoData.m (OPTIONAL)
    Density_all{m,1} = vertcat(Density{m,:});
    Area_all{m,1}= vertcat(Area{m,:});
    Locs_all{m,1}= vertcat(LocsTot{m,:});
       
end

% Generate density map (OPTIONAL)
densrend = input('Do Density rendering (Y/N)>','s');

if densrend=='Y'; 
  
for m = 1:categ
    data = Data{1,m};
    for k = 1:length(data)
        D = Insight3(data{1,k});
        xy = D.data(:,3:4);
                
        %%% Rendering of localizations in SR, with px of 10 nm size. 
        [Dens,DensFil] = DensityForSTORMImages_EdgeAnalysis(D.data(:,1),D.data(:,2),10);

        %%% FIGURE of super-resolution density map (without smoothing)
        figure(),
        imagesc(Dens), axis image, xlabel('(SR px of 10 nm)'), ylabel('(SR px of 10 nm)')
        hold on
        colormap(gray)
        title('SR Density Rendering')
        axis image
        caxis([0 3])        
               
        %%% FIGURE of super-resolution density map WITH smoothing
        figure(),
        imagesc(DensFil), axis image, xlabel('(SR px of 10 nm)'), ylabel('(SR px of 10 nm)')
        hold on
        colormap(gray)
        title('SR Density Rendering - Smoothing Kernel')
        axis image
        caxis([0 3])
        
    end
end

 else
end

% Generate matrix of results
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
EDGE_all_fortable.Properties.VariableNames  = {'Edge_Density_locs_nm2','Percentage_localizations_edge'};

INSIDE_all_fortable = array2table(vertcat(INSIDE_all{:,1}));
INSIDE_all_fortable.Properties.VariableNames  = {'Inside_Density_locs_nm2','Percentage_localizations_Inside'};

FULL_all_fortable = array2table(vertcat(FULL_all{:,1}));
FULL_all_fortable.Properties.VariableNames  = {'Full_Density_locs_nm2'};

Tabletosave = horzcat(datafortable2,EDGE_all_fortable,INSIDE_all_fortable,FULL_all_fortable);

 %%% SAVE .xlsx table with results in Folder.
 writetable(Tabletosave,strcat(Folder,'\EDGE_analysis_results.xlsx'));
