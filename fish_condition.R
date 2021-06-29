# Condition of fish using Relative Weight Analyses (Wr)
#A measurment of physical health of a population of fish based on the relative heaviness or plumpness of fish in that population
# Awhitten through the use of Ogle, 2016 chapter 8
# June 29, 2021
####################################

#packages 
library(FSA)
library(car) #before dplyr to reduce conflicts with MASS
library(magrittr)
library(dplyr) #sometimes command "select" will not run because of conflict with MASS
library(plotrix)
library(multcomp)
############################

#Set working directory
setwd ("//server/users/awhitten/Documents/Sportfish Life-History/Data") 

# Read in data
BLG<- read.csv("2015 BLG Age Length at capture.csv")

# Filter data & log weight and length
BLG<-filter(BLG, sex=="F") %>%
  mutate(logW=log10(wt), logL=log10(lencap))
headtail(BLG, n=2)
#lencap>wsBLG[["min.TL"]]) # Check to make sure fish meet min length requirement

#----Species Coeff----#
#Standard weight equation coefficients for a particular species (Neumann et al. 2012)
#http://www.imsbio.co.jp/RGM/R_rdfile?f=FSA/man/wsVal.Rd&d=R_CC
#wsVal(species="List", units=("metric"), ref=75, simplify =TRUE)# shows all species for metric

#Species Selection
wsVal("Bluegill", units="English", ref=75) #check length min and max!
wsBLG<-wsVal("Bluegill", simplify = TRUE) #coefficient extracted 
wsBLG

# Sliver Carp 
wsSCP<-c(int=-5.15756, slope=3.06842) # Lamer et al. 2015

# Bighead Carp
wsBHC<-c(int=-4.65006, slope=2.88934) # Lamer et al. 2015


#---Wr---#
#Calculate Wr using equation needed for variables provided by wsVal (see page 157 Ogle, 2016)
BLG%<>%mutate(Ws=10^(wsBLG[["int"]]+wsBLG[["slope"]]*logL), Wr=wt/Ws*100)
headtail(BLG, n=2) #values <100 indicate fish weight below standard weight of fish of the same length

