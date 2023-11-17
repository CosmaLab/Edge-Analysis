
# Edge Analysis 
These scripts can be used to calculate the percentage of localizations of a nuclear staining located at the nuclear edge (or interior) versus the total number of localizations in the nucleus.

## Input
`.bin` files (select your ROIs of interest first) 

## Output
• Percentage (%) of localizations and Density (locs/nm^2) at nuclear EDGE (and nuclear interior). Saved automatically as `.xlsx` file. In the Wokspace you can find additional information (std, se ...)

• Figure showing the density map of localizations, and the masks generated to define: the nuclear area, the edge area, and their overlay. 

• OPTIONAL FIGURES: 
- Figure of Black and White (BW) mask of the nuclear area.
- Figure of the super resolved density rendering.



  
## Composed by:
• `edgeLocDensity_MAIN.m`: Main function. to RUN.

Accessory functions:
• `edgeLocDensity.m`: 
• `DensityMap.m`: 
• `DensityForSTORMImages_EdgeAnalysis.m`: 
• `InfoData.m`:
• `Insight3.m`: 
• `uipickfiles.m`: 
• `InfoDataANDDens.m`: EXTRA function. Not used by the _MAIN code.
 


  
## Tested

Tested on Matlab_R2016b
## Authors 
- Code by Chiara Vicario, modified by Alvaro Castells Garcia, Laura Martin, Blanca Bruschi
- README and annotation by Victoria Neguembor and Laura Martin
## Deployment

To deploy this project run

```
1. Open "edgeLocDensity_MAIN.m"

2. Adjust the following parameters: 
- “Folder”: the folder in which you want the excel analysis file to be saved
- "categ = 2" adjust number of experimental categories
- "CategLabels" adjust desired names of experimental categories
- "SR_px = 20"; size of super resolution pixel
- "NPx_edge = 50"; This is the number of SR_px around the edge that will be considered as EDGE. Adjust as desired
- "nmperpx = 160" this is the original pixel size in nm (change depending on microscope: 160 for 100x Nikon NSTORM, 117 for ONI microscope)
- "sigma = 1.5"; this is the Sigma value of Gaussian smoothening used to generate the nuclear mask. Adjust as desired	

3. Run script

4. Load .bin files for each category

5. The script will generate 2 Figures per each file: one for the masks created for the edge area and the inner area, and one for the visualization of .bin file localizations

6. The script will ask you if you want to do the density rendering. Write Y or N and press Enter. (Yes to visualise, No will skip visualisation). If Y, the density rendering will appear as a third figure 

7. The analysis results will be saved as an .xlsx file. The first column reports the name of the file used for the analysis.

```

  
## Research Implementation 
Example: Methods summary for Lamin A/C and H3K9me3 quantification at nuclear edge (from Neguembor et al Mol Cell 2021): 
The percentage of Lamin A/C and H3K9me3 localizations at the edge of nucleus was calculated using a custom Matlab script, according to the following procedure. First a Gaussian filtered density map of Lamin A/C and H3K9me3 STORM coordinates was generated (pixel size 20 nm, sigma 3), then an edge of 400 nm was drawn around the nuclear rim. The percentage of localization falling in this edge was calculated as the number of localizations inside the edge region divided by the total number of localizations of the nucleus.

  
