# applied-regression-activity
Coursework from Criminological Research Methods Workshops, Lent Term, MPhil Criminology at the University of Cambridge, taught by Professor Charles Lanfear.

### Data Description
In this workshop, I created an LSOA-level dataset for London. I merged London Crime Data (Source: data.police.uk, 2022), LSOA Indices of Deprivation (Source: opendatacommunities.org, 2019), and LSOA Population Density (Source: data.london.gov.uk, 2014). 

> A Lower-layer Super Output Area (LSOA) is a small geographic unit used for statistical analysis in England and Wales [^1].

This project involves data construction, cleaning, visualization, modeling, model comparison, and interpretation. I also create visualizations and conduct linear regression analyses. I assess how deprivation is associated with violence, both independently and controlling for population density.   

### File Information
- **data:** (folder)
    - _Analysis:_ final analysis used for modeling and visualization
    - _Derived:_ cleaned and constructed datasets (crime data, population density, deprivation)
    - _Raw:_ original datasets (London Crime Data, October-December 2022)
- <ins>***applied-regression-activity.R:***</ins> Includes code for constructing the LSOA dataset by cleaning, transforming, and merging crime, deprivation, and population density data
- **applied-regression-activity.Rproj:** RStudio project file 
- <ins>***applied-regression-visualization-and-modeling.R:***</ins> Includes code for constructing visualizations, linear regression, model comparison, and interpretation.
- **imd2019lsoa.csv:** LSOA Indices of Deprivation 2019 dataset
- **land-area-population-density-lsoa11-msoa11.xlsx:** Population density dataset

### Other
- **.gitignore**
- **README.md**

[^1]: https://ocsi.uk/term/lower-layer-super-output-area-lsoa/ 
