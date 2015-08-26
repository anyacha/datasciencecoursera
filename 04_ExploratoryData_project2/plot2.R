#Coursera, Johns Hopkins U, Data Sci, course #4 Exploratory Analysis
#8/17/2015
#course project #2

### Q2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?

### Step 0. Setup
rm(list=ls())
setwd("~/Desktop/iSchool/Coursera/JohnsHopkinsU_DataScienceSpec/4ExploratoryDataAnalysis/assignments/CourseProject2")
#zip file is already downloaded and unpacked.

### Step 1. Reading in data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
#configure datatypes
NEI$fips<-as.factor(NEI$fips)
NEI$year<-as.factor(NEI$year)

### Step 2. Created dataset
#subset to Baltimore only and sum emission by year
emissions.Baltimore<-NEI[NEI$fips=="24510", ] 
emissions.Baltimore.total.byYear<-lapply(split(emissions.Baltimore$Emissions,emissions.Baltimore$year),sum)

### Step 3. Plot and answer the question
#plot total emissions by year, add custom x axis
plot(names(emissions.Baltimore.total.byYear),emissions.Baltimore.total.byYear, 
     type = "o", col="blue", lwd=2,
     main = "Baltimore: trends in total PM2.5 emission from 1999 to 2008",
     sub = "decrease in 2002, increase in 2005, and decrease in 2008",
     xlab="Year", ylab="Total emissions (in tons)", xaxt='n', ylim=range(1000:4000))
axis(1, at = c(1999, 2002, 2005,2008))

### Step 4. Create .png file
dev.copy(png, file = "plot2.png", width=900, height=480 ) 
dev.off()