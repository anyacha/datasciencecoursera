#Coursera, Johns Hopkins U, Data Sci, course #4 Exploratory Analysis
#8/17/2015
#course project #2

### Q1.  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

### Step 0. Setup
rm(list=ls())
setwd("~/Desktop/iSchool/Coursera/JohnsHopkinsU_DataScienceSpec/4ExploratoryDataAnalysis/assignments/CourseProject2")
#zip file is already downloaded and unpacked.

### Step 1. Reading in data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
#configure datatypes
NEI$year<-as.factor(NEI$year)

### Step 2. Created dataset
#sum emission by year
emissions.total.byYear<-lapply(split(NEI$Emissions,NEI$year),sum)

### Step 3. Plot and answer the question
#plot total emissions by year, add custom x axis
plot(names(emissions.total.byYear),emissions.total.byYear, type = "o", col="blue", lwd=2,
     main = "Decreasing trend in total U.S. PM2.5 emission from 1999 to 2008",
     xlab="Year", ylab="Total emissions (in tons)", xaxt='n', ylim=range(3000000:8000000))
axis(1, at = c(1999, 2002, 2005,2008))

### Step 4. Create .png file
dev.copy(png, file = "plot1.png", width=900, height=480 ) 
dev.off()