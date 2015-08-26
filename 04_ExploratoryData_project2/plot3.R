#Coursera, Johns Hopkins U, Data Sci, course #4 Exploratory Analysis
#8/17/2015
#course project #2

### Q3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
#which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
#Which have seen increases in emissions from 1999–2008? 

### Step 0. Setup
rm(list=ls())
setwd("~/Desktop/iSchool/Coursera/JohnsHopkinsU_DataScienceSpec/4ExploratoryDataAnalysis/assignments/CourseProject2")
#zip file is already downloaded and unpacked.

### Step 1. Reading in data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
#configure datatypes
NEI$fips<-as.factor(NEI$fips)
NEI$type<-as.factor(NEI$type)
NEI$year<-as.factor(NEI$year)

### Step 2. Created dataset
#subset to Baltimore only and sum emission by type and year
library(dplyr)
#note: chose to do no chaining in this exercise (totally aware of chaining, but wanted to practice)
df<-tbl_df(NEI)
df.Baltimore<-filter(df,fips=="24510")
df.Baltimore.grouped<-group_by(df.Baltimore,type,year)
df.Baltimore.summarized<-summarize(df.Baltimore.grouped, emissions.total=sum(Emissions))
head(df.Baltimore.summarized) #preview tidy dataset 

### Step 3. Plot and answer the question
#plot total Baltimore emissions by type and year
library(ggplot2)
p<-ggplot(df.Baltimore.summarized,aes(x=year,y=emissions.total,group=type, col=type))
p+geom_point( size=4) + geom_line(lwd=1.5) + 
    ggtitle("Baltimore trends in PM2.5 emission by type, from 1999 to 2008:\n'Nonpoint', 'Non-road', and 'On-Road' sources show decreases over years") +
    xlab("Year") + ylab("Total emissions (in tons)") + 
    annotate("text", x = 3, y = 1000, label = "Source type 'Point' shows increases in 2002 and 2005,\n and a sizeable decrease in 2008", col="purple")
    
### Step 4. Create .png file
dev.copy(png, file = "plot3.png", width=900, height=600 ) 
dev.off()

#extra
#reference to title and subtitle source: http://stackoverflow.com/questions/19957536/add-dynamic-subtitle-using-ggplot
plot.title = 'Baltimore trends in PM2.5 emission by type, from 1999 to 2008:\nNonpoint, Non-road, and On-Road sources show decreases over years'
plot.subtitle = 'Nonpoint, Non-road, and On-Road sources show decreases over years;\nPoint sources showed increases in emissions in 2002 and 2005, and a sizeable decrease in 2008'
