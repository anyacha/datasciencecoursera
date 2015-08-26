#Coursera, Johns Hopkins U, Data Sci, course #4 Exploratory Analysis
#8/17/2015
#course project #2

### Q5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

### Step 0. Setup
rm(list=ls())
setwd("~/Desktop/iSchool/Coursera/JohnsHopkinsU_DataScienceSpec/4ExploratoryDataAnalysis/assignments/CourseProject2")
#zip file is already downloaded and unpacked.

### Step 1. Reading in data
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")
#configure datatypes
NEI$fips<-as.factor(NEI$fips)
NEI$SCC<-as.factor(NEI$SCC)
NEI$type<-as.factor(NEI$type)
NEI$year<-as.factor(NEI$year)

### Step 2. Created dataset
#subset to Baltimore and motor vehicle sources  and sum emission by source type and year

#identify motor vehicle related sources in SCC file
#use EPA definition src http://www.epa.gov/air/emissions/basic.htm
#grep values from SCC$EI.Sector, returns a dataframe with motor vehicle related sources
scc.subset.mv<-SCC[grep("On-Road (.*) [Vv]ehicle",SCC$EI.Sector), ]
scc.sources.mv<-scc.subset.mv[,c("SCC","EI.Sector")]
unique(scc.sources.mv$EI.Sector) # confirmed 4 types of motor vechicle related emission source sectors, matches EPA definition

#subset Baltimore only
df.Baltimore<-NEI[NEI$fips=="24510",]

#merge 2 datasets and bind on SCC field
df.merged<-merge(df.Baltimore,scc.sources.mv)
summary(df.merged) #verify new field EI.Sector merged successfully

#create a tidy dataset
library(dplyr)
#note: chose to do no chaining in this exercise (totally aware of chaining, but wanted to practice)
df.mv<-tbl_df(df.merged)
df.mv<-rename(df.mv,Sector=EI.Sector)
df.mv.grouped<-group_by(df.mv,Sector,year)
df.mv.summarized<-summarize(df.mv.grouped, emissions.total=sum(Emissions))
head(df.mv.summarized)  #preview tidy dataset 

### Step 3. Plot and answer the question
#plot motor vehicle related emmissions by source sector and year, add totals
library(ggplot2)
#reference source on how to add total line
#http://stackoverflow.com/questions/17244921/ggplot2-when-i-use-stat-summary-with-line-and-point-geoms-i-get-a-double-legend
p <- ggplot(df.mv.summarized, aes(x=year, y=emissions.total)) +
    geom_line(aes(group=Sector, color=Sector)) + 
    geom_point(aes(color=Sector, shape=Sector)) + 
    stat_summary(aes(color="total",shape="total", group=1), fun.y=sum, geom="line", size=1.1) +
    scale_color_manual(values=c("orange", "green", "blue", "purple", "red")) +
    scale_shape_manual(values=c(1:4,32)) +
    ggtitle("Baltimore emissions from motor vehicle sources from 1999 to 2008\nBroken down by Sector + added a Total line") +
    xlab("Year") + ylab("Total emissions (in tons)") + 
    annotate("text", x = 3, y = 200, label = "Baltimore total emissions from motor vehicle sources \nshow decrease from 1999 to 2008", col="red" )
p
    
### Step 4. Create .png file
#dev.copy(png, file = "plot5.png", width=1200, height=600 ) 
dev.copy(png, file = "plot5.png", width=900, height=400 ) 
dev.off()