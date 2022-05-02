#
# Author:     Jesse Lecy
# Maintainer: Cristian Nuno
# Date:       March 21, 2021
# Purpose:    Create custom functions to pre-process the LTDB raw data files
#

# load necessary packages ----
library( dplyr )
library( here )
library( knitr )
library( pander )

# create custom cleaning function ----
# convert variables to numeric
# and remove missing values placeholders;
# impute missing values with mean
clean_x <- function( x )
{
  x <- as.numeric( x )
  x[ x == -999 ] <- NA
  mean.x <- mean( x, na.rm=T )
  x[ is.na(x) ] <- mean.x
  return(x)
}

# apply the clean var x function to all columns 
clean_d <- function( d, start_column )
{
  these <- start_column:ncol(d)
  d[ these ] <- lapply( d[ these ], clean_x )
  
  return( d )
}

# FIX VARIABLE NAMES
# input dataframe
# standardize variable names 
# output data frame with fixed names
fix_names <- function( d )
{
  nm <- names( d )
  nm <- tolower( nm )
  
  nm[ nm == "statea"  ] <- "state"
  nm[ nm == "countya" ] <- "county"
  nm[ nm == "tracta"  ] <- "tract"
  nm[ nm == "trtid10" ] <- "tractid"
  nm[ nm == "mar-70"  ] <- "mar70"
  nm[ nm == "mar-80"  ] <- "mar80"
  nm[ nm == "mar-90"  ] <- "mar90"
  nm[ nm == "mar.00"  ] <- "mar00"
  nm[ nm == "x12.mar" ] <- "mar12"  
  nm <- gsub( "sp1$", "", nm )
  nm <- gsub( "sp2$", "", nm )
  nm <- gsub( "sf3$", "", nm )
  nm <- gsub( "sf4$", "", nm )
  
  # nm <- gsub( "[0-9]{2}$", "", nm )
  
  names( d ) <- nm
  return( d )
}

# FIX TRACT IDS
# put into format: SS-CCC-TTTTTT
fix_ids <- function( x )
{
  x <- stringr::str_pad( x, 11, pad = "0" )
  state <- substr( x, 1, 2 )
  county <- substr( x, 3, 5 )
  tract <- substr( x, 6, 11 )
  x <- paste( "fips", state, county, tract, sep="-" )
  return(x)
}


tidy_up_data <- function( file.name )
{
  # store the file path as a character vector
  path <- paste0( "data/raw/", file.name )
  # read in the file path using here::here()
  d <- read.csv( here::here(path), colClasses="character" ) 
  type <- ifelse( grepl( "sample", file.name ), "sample", "full" )
  year <- substr( file.name, 10, 13 )
  
  # fix names 
  d <- fix_names( d )
  
  # fix leading zero problem in tract ids
  d$tractid <- fix_ids( d$tractid )
  
  # drop meta-vars
  drop.these <- c("state", "county", "tract", "placefp10",
                  "cbsa10", "metdiv10", "ccflag10", 
                  "globd10", "globg10","globd00", "globg00",
                  "globd90", "globg90","globd80", "globg80")
  d <- d[ ! names(d) %in% drop.these ]
  
  # column position where variables start after IDs
  d <- clean_d( d, start_column=2 )
  
  # add year and type (sample/full)
  d <- data.frame( year, type, d, stringsAsFactors=F )
  
  return( d )
}

build_year <- function( fn1, fn2, year )
{

  d1 <- tidy_up_data( fn1 )
  d1 <- dplyr::select( d1, - type )

  d2 <- tidy_up_data( fn2 )
  d2 <- dplyr::select( d2, - type )

  d3 <- merge( d1, d2, by=c("year","tractid"), all=T )

  # store the file path as a character vector
  file.name <- paste0( "data/rodeo/LTDB-", year, ".rds" )
  # export the object to the file path from above using here::here()
  saveRDS( d3, here::here( file.name ) )

}

# store relevant raw data files
relevant_files = list.files(here::here("data/raw"), pattern = "(s|S)td.*.csv")

# store relevant years
YEARS <- as.character(seq(1970, 2010, 10))

# create empty list
RELEVANT_FILES = list()

# for each relevant year
for (year in YEARS) {
  # extract year specific files
  year_condition = stringr::str_detect(relevant_files, year)
  # subset the relevant files
  year_files = relevant_files[year_condition]
  # subset the fullcount filename
  fullcount_file = year_files[stringr::str_detect(year_files, "fullcount")]
  # subset the sample filename
  sample_file = year_files[stringr::str_detect(year_files, "sample")]
  
  # add to the empty list
  RELEVANT_FILES[[year]] = list(
    "year" = year,
    "fullcount" = fullcount_file,
    "sample" = sample_file
  )
}
  
obtain_crosswalk = function() {
  # store crosswalk URL
  URL <- "https://data.nber.org/cbsa-msa-fips-ssa-county-crosswalk/cbsatocountycrosswalk.csv"
  # read in as data frame
  cw <- read.csv( URL, colClasses="character" )
  # note in the data dictionary for CBSA Name (copied below): “blanks are rural”
  cw$urban <- ifelse( cw$cbsaname == "", "rural", "urban" )
  # store relevant columns
  keep.these <- c( "countyname","state","fipscounty", 
                   "msa","msaname", 
                   "cbsa","cbsaname",
                   "urban" )
  # filter the crosswalk
  cw <- dplyr::select( cw, keep.these )
  
  # drop the duplicated fips county codes
  cw <- cw[ ! duplicated(cw$fipscounty) , ]
  
  # save for future use
  saveRDS( cw, here::here( "data/raw/cbsa-crosswalk.rds") )
  
  # return to user
  return(cw)
}

extract_metadata <- function( file.name )
{
  # store the file path as a character vector
  path <- paste0( "data/raw/", file.name )
  # import the file using the file path inside of here::here()
  d <- read.csv( here::here( path ), colClasses="character" )
  type <- ifelse( grepl( "sample", file.name ), "sample", "full" )
  year <- substr( file.name, 10, 13 )

  # fix names
  d <- fix_names( d )

  # fix leading zero problem in tract ids
  d$tractid <- fix_ids( d$tractid )

  # drop meta-vars
  keep.these <- c("tractid","state", "county", "tract", "placefp10",
                  "cbsa10", "metdiv10", "ccflag10",
                  "globd10", "globg10","globd00", "globg00",
                  "globd90", "globg90","globd80", "globg80")
  d <- d[ names(d) %in% keep.these ]
  return( d )
}

# make final metadata file
create_final_metadata_file = function(file_names, crosswalk) {
  # filter the crosswalk
  # note: unique ID still persists through the FIPS column
  cw = dplyr::select(crosswalk, -countyname, -state)
  
  # extract metadata for 1980-2000
  md_2000 <- extract_metadata( file.name=file_names[["2000"]][["fullcount"]] )
  
  md_1990 <- extract_metadata( file.name=file_names[["1990"]][["fullcount"]] )
  md_1990 <- dplyr::select( md_1990, tractid, globd90, globg90 )
  
  md_1980 <- extract_metadata( file.name=file_names[["1980"]][["fullcount"]] )
  md_1980 <- dplyr::select( md_1980, tractid, globd80, globg80 )
  
  # merge metadata into one data frame
  # note: these are outer joins, meaning if a record from 2000 isn't found in
  #       in 1990, those "missing" records are still returned
  md_complete <- merge( md_2000, md_1990, all=T )
  md_complete <- merge( md_complete, md_1980, all=T )
  
  # create the fips county column
  # TODO: avoid hard coding index values
  md_complete$fipscounty <- paste0( substr( md_complete$tractid, 6, 7 ),
                               substr( md_complete$tractid, 9, 11 ) )
  
  # merge fips data onto metadata
  # note: this is a left join, all records from md_complete will be returned
  md_complete_with_cw <- merge( md_complete, 
                                cw, 
                                by="fipscounty", 
                                all.x=T )
  
  # save metadata
  saveRDS( md_complete_with_cw, here::here( "data/rodeo/LTDB-META-DATA.rds" ) )
}

# note: please do not use static file paths
# note: notice down below the use of here::here()
d1 <- readRDS( here::here( "data/rodeo/LTDB-1990.rds" ) )
d2 <- readRDS( here::here( "data/rodeo/LTDB-2000.rds" ) )
md <- readRDS( here::here( "data/rodeo/LTDB-META-DATA.rds" ) )
# check to make sure we are not losing 
# or gaining observations in the merge
#nrow( d1 ) 

d1 <- select( d1, - year )
d2 <- select( d2, - year )
d <- merge( d1, d2, by="tractid" )
d <- merge( d, md, by="tractid" )
# nrow( d )

d <- filter( d, urban == "urban" )

# find common variables in both files
compare_dfs <- function( df1, df2 )
{
  # use regular expressions to remove numeric suffixes 
  var.names.1 <- names( df1 )
  var.names.1 <- gsub( "[.][xy]$", "", var.names.1 )
  var.names.1 <- gsub( "[0-9]{2}$", "", var.names.1 )
  
  var.names.2 <- names( df2 )
  var.names.2 <- gsub( "[.][xy]$", "", var.names.2 )
  var.names.2 <- gsub( "[0-9]{2}$", "", var.names.2 )
  
  shared <- intersect( var.names.1, var.names.2 ) %>% sort()
  print( "SHARED VARIABLES:")
  print( shared )
  
  not.shared <- c( setdiff( var.names.1, var.names.2 ),
                   setdiff( var.names.2, var.names.1 ) ) %>% sort()
  
  print( "NOT SHARED:" )
  print( not.shared )
  
  d.vars1 <- data.frame( type="shared", variables=shared, stringsAsFactors=F )
  d.vars2 <- data.frame( type="not shared", variables=not.shared, stringsAsFactors=F )
  dd <- rbind( d.vars1, d.vars2 )
  
  return( dd )
}
vars <- compare_dfs( df1=d1, df2=d2 )

d.full <- d  # keep a copy so don't have to reload 

# select 1990 variables
d <- d.full  # store original in case you need to reset anything
d <- select( d, tractid, mhmval90, mhmval00, hinc90, hinc00, 
             hu90, own90, rent90,  
             empclf90, clf90, unemp90, prof90,  
             dpov90, npov90,
             ag25up90, hs90, col90, 
             pop90.x, nhwht90, nhblk90, hisp90, asian90,  ## ? pop90 or pop90.x
             cbsa, cbsaname )
d <- 
  d %>%
  mutate( p.white = 100 * nhwht90 / pop90.x,
          p.black = 100 * nhblk90 / pop90.x,
          p.hisp = 100 * hisp90 / pop90.x, 
          p.asian = 100 * asian90 / pop90.x,
          p.hs = 100 * (hs90+col90) / ag25up90,
          p.col = 100 * col90 / ag25up90,
          p.prof = 100 * prof90 / empclf90,
          p.unemp = 100 * unemp90 / clf90,
          pov.rate = 100 * npov90 / dpov90 )

# adjust 1990 home values for inflation, at 1.28855%
mhv.90 <- d$mhmval90 * 1.28855
mhv.00 <- d$mhmval00
mhv.change <- mhv.00 - mhv.90
df <- data.frame( MedianHomeValue1990=mhv.90, 
                  MedianHomeValue2000=mhv.00, 
                  Change.90.to.00=mhv.change )


# function to control plot() formatting 
jplot <- function( x1, x2, lab1="", lab2="", draw.line=T, ... )
{
  plot( x1, x2,
        pch=19, 
        col=gray(0.6, alpha = 0.2), 
        cex=2.5,  
        bty = "n",
        xlab=lab1, 
        ylab=lab2, cex.lab=1.5,
        ... )
  if( draw.line==T ){ 
    ok <- is.finite(x1) & is.finite(x2)
    lines( lowess(x2[ok]~x1[ok]), col="red", lwd=3 ) }
}

# remove 1990 homes valued at less than $10,000 (presumably empty lots)
mhv.90[ mhv.90 < 10000 ] <- NA
pct.change <- mhv.change / mhv.90

d$mhv.change <- mhv.change 
d$pct.change <- pct.change
d$mhv.00 <- mhv.00
d$mhv.90 <- mhv.90

d.full$mhv.90 <- mhv.90
d.full$mhv.00 <- mhv.00
d.full$mhv.change <- mhv.change
d.full$pct.change <- pct.change


d3 <- select( d.full, 
              
              tractid, cbsa, cbsaname,            # ids / units of analysis
              
              mhv.90, mhv.00, mhv.change, pct.change,    # home value 
              
              mrent90, mrent00,                   # rent
              
              vac90, vac00,                       # vacant units
              
              hinc90, hu90, own90, rent90,        # ses
              hinc00, hu00, own00, rent00,
              
              empclf90, clf90, unemp90, prof90,   # employment 
              empclf00, clf00, unemp00, prof00,
              
              dpov90, npov90,                     # poverty
              dpov00, npov00,
              
              ag25up90, hs90, col90,              # education 
              ag25up00, hs00, col00,
              
              pop90.x, nhwht90, nhblk90, hisp90, asian90,   # race
              pop00.x, nhwht00, nhblk00, hisp00, asian00
              
) # end select

d3 <- 
  d3 %>%
  mutate( 
    # 1990 variables
    p.white.90 = 100 * nhwht90 / pop90.x,
    p.black.90 = 100 * nhblk90 / pop90.x,
    p.hisp.90 = 100 * hisp90 / pop90.x, 
    p.asian.90 = 100 * asian90 / pop90.x,
    p.hs.edu.90 = 100 * (hs90+col90) / ag25up90,
    p.col.edu.90 = 100 * col90 / ag25up90,
    p.prof.90 = 100 * prof90 / empclf90,
    p.unemp.90 = 100 * unemp90 / clf90,
    pov.rate.90 = 100 * npov90 / dpov90,
    p.vac.90 = 100 * vac90 / hu90,
    
    # 2000 variables
    p.white.00 = 100 * nhwht00 / pop00.x,
    p.black.00 = 100 * nhblk00 / pop00.x,
    p.hisp.00 = 100 * hisp00 / pop00.x, 
    p.asian.00 = 100 * asian00 / pop00.x,
    p.hs.edu.00 = 100 * (hs00+col00) / ag25up00,
    p.col.edu.00 = 100 * col00 / ag25up00,
    p.prof.00 = 100 * prof00 / empclf00,
    p.unemp.00 = 100 * unemp00 / clf00,
    pov.rate.00 = 100 * npov00 / dpov00, 
    p.vac.00 = 100 * vac00 / hu00
  )

d3 <-
  d3 %>%
  group_by( cbsaname ) %>%
  mutate( metro.mhv.pct.90 = ntile( mhv.90, 100 ),
          metro.mhv.pct.00 = ntile( mhv.00, 100 ),
          metro.median.pay.90 = median( hinc90, na.rm=T ),
          metro.median.pay.00 = median( hinc00, na.rm=T ),
          metro.race.rank.90 = ntile( (100-p.white.90), 100 ) ) %>%
  ungroup() %>%
  mutate( metro.mhv.pct.change = metro.mhv.pct.00 - metro.mhv.pct.90,
          pay.change = metro.median.pay.00 - metro.median.pay.90,
          race.change = p.white.00 - p.white.90,
          mhv.change = mhv.00 - mhv.90 )


# Descriptive Statistics of Change Variables
d3 <-           
  d3 %>%
  select( c( "tractid", "cbsa", "cbsaname",
             "mhv.90", "mhv.00", "mhv.change","pct.change",
             "p.white.90", "p.black.90", "p.hisp.90", "p.asian.90", 
             "p.hs.edu.90", "p.col.edu.90", "p.prof.90",  "p.unemp.90", 
             "pov.rate.90", "mrent90", "p.vac.90", "p.white.00", "p.black.00", "p.hisp.00", 
             "p.asian.00", "p.hs.edu.00", "p.col.edu.00", "p.prof.00", 
             "p.unemp.00", "pov.rate.00", "metro.mhv.pct.90", 
             "metro.mhv.pct.00", "metro.median.pay.90", "metro.median.pay.00", 
             "metro.mhv.pct.change", "pay.change", "race.change",
             "metro.race.rank.90") ) 

# gentrification eligibility criteria
# home value in lower than average home in a metro in 1990
lowhomeval.1990 <- d3$metro.mhv.pct.90 < 50  
# vacancies above 75th percentile
vacant.1990 <- d3$p.vac.90 > 9
# median rent below the 25th percentile
lowrent.1990 <- d3$mrent90 < 168
# above average diversity for metro
diverse.1990 <- d3$metro.race.rank.90 > 50 
# unemployment above 75th percentile
unemployment.1990 <- d3$p.unemp.90 > 8
# college or more education below the 25th percentile
lowed.1990 <- d3$p.col.edu.90 < 10
# poverty rate above 75h percentile
highpoverty.1990 <- d3$pov.rate.90 > 16

# gentrification identification
# home values increased more than overall city gains 
# change in percentile rank within the metro
mhv.pct.increase <- d3$metro.mhv.pct.change > 0
# faster than average growth  
# 25% growth in value is median for the country
home.val.rise <- d3$pct.change > 25 
# proportion of whites increases by more than 3 percent 
# measured by increase in white
loss.diversity <- d3$race.change > 3 

crosswalk <- read.csv( "https://raw.githubusercontent.com/DS4PS/cpp-529-master/master/data/cbsatocountycrosswalk.csv",  stringsAsFactors=F, colClasses="character" )
# search for city names by strings, use the ^ anchor for "begins with" 

these.MKE <- crosswalk$msaname == "MILWAUKEE-WAUKESHA, WI"
these.fips <- crosswalk$fipscounty[ these.MKE ]
these.fips <- na.omit( these.fips )
state.fips <- substr( these.fips, 1, 2 )
county.fips <- substr( these.fips, 3, 5 )
MKE <-
  get_acs( geography = "tract", variables = "B01003_001",
           state = "55", county = county.fips[state.fips=="55"], 
           geometry = TRUE, progress_bar = FALSE ) %>% 
  select( GEOID, estimate ) %>%
  rename( POP=estimate )

# create small dataframe for the merge for mapping
df.2 <- data.frame(  tractid=d$tractid, 
                     mhv.90, mhv.00,  mhv.change,  pct.change, loss.diversity, lowhomeval.1990,
                     unemployment.1990, d3$p.unemp.90, d3$p.unemp.00, d3$pov.rate.90, d3$pov.rate.00, d3$pay.change, 
                     d3$race.change )
# create GEOID that matches GIS format
# create a geoID for merging by tract 
df.2$GEOID <- substr( df.2$tractid, 6, 18 )  # extract codes
df.2$GEOID <- gsub( "-", "", df.2$GEOID )    # remove hyphens

mke <- merge( MKE, df.2, by.x="GEOID", by.y="GEOID" )
