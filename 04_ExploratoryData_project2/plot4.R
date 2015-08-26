#Coursera, Johns Hopkins U, Data Sci, course #4 Exploratory Analysis
#8/17/2015
#course project #2

### Q4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

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
#subset to coal combustion-related sources only and sum emission by source sector and year

#identify coal combustion-related sources in SCC file
#use EPA definition src http://www.epa.gov/air/emissions/basic.htm
#grep values from SCC$EI.Sector, returns a dataframe with coal combustion-related sources
scc.subset.coal<-SCC[grep("[Cc]omb (.*) [Cc]oal",SCC$EI.Sector), ]
scc.sources.coal<-scc.subset.coal[,c("SCC","EI.Sector")]
unique(scc.sources.coal$EI.Sector) #3 types of coal combustion-related emission source sectors, matches EPA definition
#merge 2 datasets and bind on SCC field
df.merged<-merge(NEI,scc.sources.coal)
summary(df.merged) #verify new field EI.Sector merged successfully

#create a tidy dataset
library(dplyr)
#note: chose to do no chaining in this exercise (totally aware of chaining, but wanted to practice)
df.coal<-tbl_df(df.merged)
df.coal<-rename(df.coal,Sector=EI.Sector)
df.coal.grouped<-group_by(df.coal,Sector,year)
df.coal.summarized<-summarize(df.coal.grouped, emissions.total=sum(Emissions))
head(df.coal.summarized)  #preview tidy dataset 

### Step 3. Plot and answer the question
#plot coal combustion-related emmissions by emission source sector (EI.Sector field) and year, add totals
library(ggplot2)
#reference source on how to add total line
#http://stackoverflow.com/questions/17244921/ggplot2-when-i-use-stat-summary-with-line-and-point-geoms-i-get-a-double-legend
p4 <- ggplot(df.coal.summarized, aes(x=year, y=emissions.total)) +
    geom_line(aes(group=Sector, color=Sector)) + 
    geom_point(aes(color=Sector, shape=Sector)) + 
    stat_summary(aes(color="total",shape="total", group=1), fun.y=sum, geom="line", size=1.1) +
    scale_color_manual(values=c( "green", "orange", "blue", "red")) +
    scale_shape_manual(values=c(1:3,32)) +
    ggtitle("U.S. emissions from coal combustion-related sources from 1999 to 2008\nBroken down by Sector + added a Total line") +
    xlab("Year") + ylab("Total emissions (in tons)") + 
    annotate("text", x = 2.5, y = 580000, label = "Total emissions from coal show decrease from 1999 to 2008", col="red" )
p4
    
### Step 4. Create .png file
dev.copy(png, file = "plot4.png", width=900, height=400 ) 
dev.off()