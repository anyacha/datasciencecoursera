#Coursera, Johns Hopkins U, Data Sci, course #4 Exploratory Analysis
#8/17/2015
#course project #2

### Q6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
### Which city has seen greater changes over time in motor vehicle emissions?
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
#subset to Baltimore+LA and motor vehicle sources  and sum emission by fips, source type and year

#identify motor vehicle related sources in SCC file
#use EPA definition src http://www.epa.gov/air/emissions/basic.htm
#grep values from SCC$EI.Sector, returns a dataframe with motor vehicle related sources
scc.subset.mv<-SCC[grep("On-Road (.*) [Vv]ehicle",SCC$EI.Sector), ]
scc.sources.mv<-scc.subset.mv[,c("SCC","EI.Sector")]
unique(scc.sources.mv$EI.Sector) # confirmed 4 types of motor vechicle related emission source sectors, matches EPA definition

#subset Baltimore and LA only
df.BaltimoreAndLA<-NEI[NEI$fips  %in% c("24510","06037"),]

#merge 2 datasets and bind on SCC field
df.merged<-merge(df.BaltimoreAndLA,scc.sources.mv)
summary(df.merged) #verify new field EI.Sector merged successfully

#create a tidy dataset
library(dplyr)
#note: chose to do no chaining in this exercise (totally aware of chaining, but wanted to practice)
df.final<-tbl_df(df.merged)
df.final<-rename(df.final,Sector=EI.Sector)
df.final.grouped<-group_by(df.final,fips,Sector,year)
df.final.summarized<-summarize(df.final.grouped, emissions.total=sum(Emissions))
head(df.final.summarized)  #preview tidy dataset 
df.final.summarized$county<-factor(df.final.summarized$fips, labels=c("Los Angeles", "Baltimore"))

#confirm records - do same diff way
df<-tbl_df(NEI)
df.confirm<-filter(df,SCC %in% scc.sources.mv$SCC, fips %in% c("24510","06037")) #same 2099 records as in fd.final
df.confirm.grouped<-group_by(df.confirm,fips,year)
df.confirm.summarized<-summarize(df.confirm.grouped,emissions.total=sum(Emissions))

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
    ggtitle("Baltimore emissions from motor vehicle sources from 1999 to 2008\nBroken down by Sector + added a Total line") +
    xlab("Year") + ylab("Total emissions (in tons)") + 
    annotate("text", x = 3, y = 200, label = "Baltimore total emissions from motor vehicle sources show decrease from 1999 to 2008", col="red" )
p
#reference source on how to add annotation to a faceted ggplot
#http://stackoverflow.com/questions/11889625/annotating-text-on-individual-facet-in-ggplot2
ann_text <- data.frame(year = 2.5,emissions.total = 4000,lab = "Total motor vehicle emissions in Los Angeles county are \nsignificantly higher compared to Baltimore",
                       county = factor("Baltimore",levels = c("Los Angeles","Baltimore")))

p1<- ggplot(df.final.summarized, aes(x=year, y=emissions.total)) +
    geom_line(aes(group=Sector, color=Sector)) + 
    geom_point(aes(color=Sector, shape=Sector)) +
    stat_summary(aes(color="total",shape="total", group=1), fun.y=sum, geom="line", size=1.5) +
    scale_color_manual(values=c("orange", "green", "blue", "purple", "red")) +
    scale_shape_manual(values=c(1:4,32)) +
    ggtitle("Emissions from motor vehicle sources, Los Angeles vs. Baltimore City\nBroken down by Sector + added a Total line") +
    xlab("Year") + ylab("Total emissions (in tons)") + 
    facet_grid(. ~ county) + 
    geom_text(data = ann_text,aes(label =lab),color="red" )
p1
    
### Step 4. Create .png file
dev.copy(png, file = "plot6.png", width=1600, height=800 ) 
dev.off()

