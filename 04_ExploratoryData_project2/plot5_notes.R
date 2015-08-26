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
#subset to Baltimore and motor vehicle related sources; sum emission by source sector and year

#identify motor vehicle related sources in SCC file
#use EPA definition src http://www.epa.gov/air/emissions/basic.htm
#grep values from SCC$EI.Sector, returns a dataframe with motor vehicle related sources
scc.subset.mv<-SCC[grep("On-Road (.*) [Vv]ehicle",SCC$EI.Sector), ]
scc.sources.mv<-scc.subset.mv[,c("SCC","EI.Sector")]
unique(scc.sources.mv$EI.Sector) # confirmed 4 types of motor vechicle related source sectors, matches EPA definition

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

#confirm records - do same diff way
df<-tbl_df(NEI)
df.Baltimore.motorvehicle.related<-filter(df,SCC %in% scc.sources.mv$SCC, fips=="24510")
df.Baltimore.motorvehicle.grouped<-group_by(df.Baltimore.motorvehicle.related,year)
df.Baltimore.motorvehicle.summarized<-summarize(df.Baltimore.motorvehicle.grouped,count=n(), emissions.total=sum(Emissions))

### Step 3. Plot and answer the question
#plot coal combustion-related emmissions by emission source sector (EI.Sector field) and year, add totals
library(ggplot2)
#reference source on how to add total line
#http://stackoverflow.com/questions/17244921/ggplot2-when-i-use-stat-summary-with-line-and-point-geoms-i-get-a-double-legend
p <- ggplot(df.mv.summarized, aes(x=year, y=emissions.total)) +
    geom_line(aes(group=Sector, color=Sector)) + 
    geom_point(aes(color=Sector, shape=Sector)) + 
    stat_summary(aes(color="total",shape="total", group=1), fun.y=sum, geom="line", size=1.1) +
    scale_color_manual(values=c( "green", "orange", "blue", "purple", "red")) +
    scale_shape_manual(values=c(1:4,32)) +
    ggtitle("Baltimore emissions from motor vehicle sources from 1999–2008\nBroken down by Sector + added a Total line") +
    xlab("Year") + ylab("Total emissions (in tons)") + 
    annotate("text", x = 3, y = 200, label = "Baltimore emissions from motor vehicle sources show decrease from 1999–2008", col="red" )
p
    
### Step 4. Create .png file
dev.copy(png, file = "plot5.png", width=1200, height=600 ) 
dev.off()






#Q6.  Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
#Which city has seen greater changes over time in motor vehicle emissions?
#still need stuff from before, get code from Q5
df.motorvechcle.BaltimoreAndLA<-filter(df,SCC %in% scc.source.motorvehicle, fips %in% c("24510","06037"))
summary(df.motorvechcle.BaltimoreAndLA)
nrow(df.motorvechcle.BaltimoreAndLA)
#didn't work df.motorvechcle.BaltimoreAndLA.mutated<-mutate(df.motorvechcle.BaltimoreAndLA, if (fips=="24510") {county="Baltimore"} else {county="Los Angeles County"}) 
df.motorvechcle.BaltimoreAndLA.grouped<-group_by(df.motorvechcle.BaltimoreAndLA,fips,year)
df.motorvechcle.BaltimoreAndLA.summarized<-summarize(df.motorvechcle.BaltimoreAndLA.grouped,emissions.total=sum(Emissions))
p<-ggplot(df.motorvechcle.BaltimoreAndLA.summarized,aes(x=year,y=emissions.total,group=fips,col=fips))
p+geom_line() + geom_point() +
    scale_colour_discrete(name="County", labels=c("Baltimore", "Los Angeles"))

