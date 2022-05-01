# CPP-528
CPP-528 Spring 2022 Session B
<br>
Team 2 Final Project

This project was completed for the [Arizona State University](asu.edu) course CPP-528, Foundations of Data Science Part III: Project management for data analysts, part of the [Program Evaluation and Data Analytics masters program](https://ds4ps.org/ms-prog-eval-data-analytics/).

US Census data were used to evaluate the impact of two tax credit programs, New Market Tax Credits and Low Income Housing Tax Credits, using median home values as an indicator of improved neighborhood wellbeing. 

**Team Members**
<br>
Sarah Johaningsmeir, https://github.com/Johaning
<br>
Caitlyn Mccullers, https://github.com/ctmccull
<br>
Ahmed Radwan, https://github.com/radwan-a
<br>
Mohamed Said, https://github.com/mbsaid


**Replication Tips**
<br>
<br>
This project was completed using R 4.1.0, RStudio, GitHub, and GitHub Desktop.
<br>
<br>
In this repository, you will find a renv.lock file. Should you want to replicate this study, you will need to run the renv::restore() function to install all packages and their dependencies involved in this project.
<br>
<br>
**Data Files**
<br>
<br>
You will find the Census Longitudinal Tabulated Database (LTDB) file here:
<br>
[Harmonized Census Data](https://github.com/ctmccull/CPP528_TEAM2_Spring2022/tree/main/data/raw)
<br>
[Cleaned Data](https://github.com/ctmccull/CPP528_TEAM2_Spring2022/tree/main/data/rodeo)
<br>
[Codebook](https://watts-college.github.io/cpp-528-spr-2022/data/LTDB-codebook.pdf)
<br>
<br>
Low Income Housing Tax Credit (LIHTC) data files are stored here:
<br>
[LIHTC Data Dictionary](https://github.com/ctmccull/CPP528_TEAM2_Spring2022/blob/main/data/raw/LIHTC%20Data%20Dictionary%202017.pdf)
<br>
[LIHTC Raw Data](https://github.com/ctmccull/CPP528_TEAM2_Spring2022/blob/main/data/raw/LIHTCPUB.csv)
<br>
<br>
New Market Tax Credit (NMTC) data files are stored here:
<BR>
[NMTC Data Dictionary](https://github.com/ctmccull/CPP528_TEAM2_Spring2022/blob/main/data/raw/2019%20NMTC%20Public%20Data%20Release_FY_17.xlsx)
<br>
[NMTC_Sheet_1](https://github.com/ctmccull/CPP528_TEAM2_Spring2022/blob/main/data/raw/nmtc-sheet-01.csv)
<br>
[NMTC Sheet 2](https://github.com/ctmccull/CPP528_TEAM2_Spring2022/blob/main/data/raw/nmtc-sheet-02.csv)
<br>
<br>
  
**Required Packages**
  
<br>
To install required packages you can restore packages dependencies from renv.lock file that is located in [renv](https://github.com/ctmccull/CPP528_TEAM2_Spring2022/tree/main/renv) folder. Use the code renv::restore(here::here())

<br>
<br>
  
**Licensing**

<br>
The project is licensed under MIT open source license. For more details check [license](https://github.com/ctmccull/CPP528_TEAM2_Spring2022/blob/main/LICENSE) file.

<br>
<br>
<br>
  
**Bibliography**
  
<br>
  
- Bartik, Timothy. New database and report reveal how much states spend on incentives to entice businesses. *W.E. Upjohn Institute for Employment Research.* Available [here](https://www.upjohn.org/research-highlights/new-database-and-report-reveal-how-much-states-spend-incentives-entice-businesses)
- Bryan, Jenny. naming things. Available [here](https://www2.stat.duke.edu/~rcs46/lectures_2015/01-markdown-git/slides/naming-slides/naming-slides.pdf)
- Burnette, Caroline (2017). Predicting Revitalization: A Descriptive Narrative and Predictive Analysis of Neighborhood. *Georgia Institute of Technology.* Available [here](https://watts-college.github.io/cpp-528-spr-2022/articles/revitalization/predicting-revitalization.pdf)
- Crane & Manville (2008). People or Place? Revisiting the Who Versus the Where of Urban Development. *Lincoln Institute of Land Policy.* Available [here]( https://watts-college.github.io/cpp-528-spr-2022/articles/revitalization/people-or-place-revisiting-the-debate.pdf)
- Gentrification and Displacement Census Tract Typologies. Available [here](https://github.com/DS4PS/cpp-528-spr-2020/blob/master/articles/gentrification/gentrification-methodology.pdf)
- Glaeser, Edward (2005). Should the Government Rebuild New Orleans, Or Just Give Residents Checks? Available [here](https://are.berkeley.edu/~ligon/Teaching/EEP100/glaeser05.pdf)
- Glaeser, Edward (2007). Can Buffalo Ever Come Back? *City Journal.* Available [here](https://www.city-journal.org/html/can-buffalo-ever-come-back-13050.html)
- Glaeser & Gottlieb (2008). The Economics of Place Making Policies. *Brookings Papers on Economic Activity.* Available [here](https://github.com/DS4PS/cpp-528-spr-2020/raw/master/articles/revitalization/the-economics-of-place-making-policies.pdf)
- Hedonic Pricing Method (2015). Available [here](https://watts-college.github.io/cpp-528-template/articles/home-value-change/hedonic-pricing-method.pdf)
- Herriges, Daniel (2017). Who Benefits From Neighborhood Improvements? *Strong Towns.* Available [here](https://www.strongtowns.org/journal/2017/11/1/who-benefits-from-neighborhood-improvements)
- Herriges, Daniel (2019). Untangling Gentrification and Displacement: a New NYU Study Helps. *Strong Towns.* Available [here](https://www.strongtowns.org/journal/2019/8/1/untangling-gentrification-and-displacement)
- Leaper, Nicole. a visual guide to CRISP-DM methodology. Available [here](https://exde.files.wordpress.com/2009/03/crisp_visualguide.pdf)
- Lecy, Jesse (2018). Syracuse Land Bank: Final Project for DDMII Independent Study. Available [here](https://lecy.github.io/SyracuseLandBank/litreview.html)
- Maciag, Mike (2015). Gentrification in America Report. Available [here](https://github.com/DS4PS/cpp-528-spr-2020/blob/master/articles/gentrification/gentrification-in-america-report.pdf)
- Matt.0 (2018). The Gold Standard of Data Science Project Management. Available [here](https://towardsdatascience.com/the-gold-standard-of-data-science-project-management-13d68c9e85d6)
- Monson, M. (2009). Valuation using hedonic pricing models. *Cornell Real Estate Review*, 7, 62-73. Available [here](https://watts-college.github.io/cpp-528-template/articles/home-value-change/valuation-using-hedonic-pricing-models.pdf)
- Opportunity zones and New Markets Tax Credits (NMTC) interactive map. *Cohn Reznick.* Available [here](https://www.cohnreznick.com/nmtc-map)
- Quantum (2019). Data Science project management methodologies. *Data Driven Investor.* Available [here](https://medium.datadriveninvestor.com/data-science-project-management-methodologies-f6913c6b29eb)
- Rothwell, Jonathan (2015). Sociology’s revenge: Moving to Opportunity (MTO) revisited. *Bookings.* Available [here](https://www.brookings.edu/blog/social-mobility-memos/2015/05/06/sociologys-revenge-moving-to-opportunity-mto-revisited/)
- Schill, Ellen, Schwartz, & Voicu (2002). Revitalizing Inner City Neighborhoods: New York City’s Ten Year Plan. *New York University.* Available [here](https://github.com/DS4PS/cpp-528-spr-2020/raw/master/articles/revitalization/Revitalizing_Inner_City_Neighborhoods.pdf)
- Tatian, Kingsley, Parilla, & Pendall (2012). Building Successful Neighborhoods. *What Works Collaborative.* Available [here](https://watts-college.github.io/cpp-528-spr-2022/articles/revitalization/building-successful-neighborhoods.pdf)



