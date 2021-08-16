
# Edge Analysis 
These scripts can be used to calculate the percentage of localizations of a nuclear staining located at the nuclear edge (or interior) versus the total number of localizations in the nucleus.

## Input
`.bin` files (select your ROIs of interest first) 

## Output
• % of localizations and densities at nuclear edge and nuclear interior are found in Workspace and are saved automatically as `.xls` file.

• Two `.fig` are produced for every cell, one with the localizations of the .bin file, and one with the masks generated to define the nuclear area, the edge area, and their overlay. A third .fig is generated for the density rendering (optional).



  
## Composed by:
• `edgeLocDensity_main.m`: Main function you need to open just this file

• `edgeLocDensity.m`: accessory function
 


  
## Tested

Tested on Matlab_R2016b
## Authors 
- Code by Chiara Vicario, modified by Alvaro Castells Garcia
- README and annotation by Victoria Neguembor
## Deployment

To deploy this project run

```
1. Open "edgeLocDensity_main.m"

2. Adjust the following parameters: 
- "categ = 2" adjust number of experimental categories
- “Folder”: the folder in which you want the excel analysis file to be saved
- "CategLabels" adjust desired names of experimental categories
- "Colors" choose desired color code or go for random colors assignation (colormap(jet()) function)
- "SR_px = 20"; normally works fine with 20 nm but can be modified
- "NPx_edge = 50"; This is the number of SR_px around the edge that will be considered as edge, adjust as desired
- "nmperpx = 160" this is the original pixel size in nm (change depending
       on microscope) 160 for 100x Nikon NSTORM, 117 for ONI microscope
- "sigma = 1.5"; this is the Sigma value of Gaussian, adjust if desired	

3. Run script

4. Load .bin files for each category

5. The script will generate 2 Figures per each file: one for the masks created for the edge area and the inner area, and one for the visualization of .bin file localizations

6. The script will ask you if you want to do the density rendering. Write Y or N and press Enter. (Yes to visualise, No will skip visualisation). If Y, the density rendering will appear as a third figure 

7. The analysis results will be saved on an excel file, with the name of the file used for the analysis in the first column.

```

  
## Research Implementation 
Example Methods summary for Voronoi cumulative distribution (from Neguembor et al Mol Cell 2021): 
Lamin A/C and H3K9me3 quantification at nuclear edge. The percentage of Lamin A/C and H3K9me3 localizations at the edge of nucleus was calculated using a custom Matlab script, according to the following procedure. First a Gaussian filtered density map of Lamin A/C and H3K9me3 STORM coordinates was generated (pixel size 20 nm, sigma 3), then an edge of 400 nm was drawn around the nuclear rim. The percentage of localization falling in this edge was calculated as the number of localizations inside the edge region divided by the total number of localizations inside the nucleus.

  