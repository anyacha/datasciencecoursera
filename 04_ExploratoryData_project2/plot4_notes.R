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
#subset to coal combustion-related sources only and sum emission by source type and year

#identify coal combustion-related sources in SCC file
#use EPA definition src http://www.epa.gov/air/emissions/basic.htm
#grep values from SCC$EI.Sector, returns a dataframe with coal combustion-related sources
scc.subset.coal<-SCC[grep("[Cc]omb (.*) [Cc]oal",SCC$EI.Sector), ]
scc.sources.coal<-scc.subset.coal[,c("SCC","EI.Sector")]
unique(scc.sources.coal$EI.Sector) #3 types of coal combustion-related sources, matches EPA definition
#merge 2 datasets and bind on SCC field
df.merged<-merge(NEI,scc.sources.coal)
summary(df.merged) #verify new field EI.Sector merged successfully

#create a tidy dataset
library(dplyr)
#note: chose to do no chaining in this exercise (totally aware of chaining, but wanted to practice)
df.coal<-tbl_df(df.merged)
df.coal.grouped<-group_by(df.coal,EI.Sector,year)
df.coal.summarized<-summarize(df.coal.grouped, emissions.total=sum(Emissions))
head(df.coal.summarized)  #preview tidy dataset 

### Step 3. Plot and answer the question
#plot coal combustion-related emmissions by EI.Industry and year, add totals
library(ggplot2)

#example 1 - plot by source and sector, no totals
p<-ggplot(df.coal.summarized,aes(x=year,y=emissions.total,group=EI.Sector, col=EI.Sector))
p+geom_point( size=4) + geom_line(lwd=1.5) + 
    ggtitle("U.S.coal combustion-related emissions by EI.Sector, from 1999–2008") +
    xlab("Year") + ylab("Total emissions (in tons)") + 
    annotate("text", x = 3, y = 1000, label = "abc", col="red")

#want to add totals, i.e. works with mean (src search by ggplot stat_summary)
p1 <- ggplot(df.coal.summarized, aes(x=year, y=emissions.total, color=factor(EI.Sector))) +geom_point()   
p1 + stat_summary(fun.y = "mean", fun.ymin = "mean", fun.ymax = "mean", 
    colour = "black", aes(shape="total"), geom="point") +
    guides(colour=guide_legend(order=1), shape=guide_legend(title=NULL, order=2))

#does it work with totals? not exactly, data is plotted, but can't get my shapes and legend
p2 <- ggplot(df.coal.summarized, aes(x=year, y=emissions.total, color=EI.Sector, group=EI.Sector)) +geom_point()   + geom_line()
p2 + stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", 
    #colour = "black", geom="line",  aes(group=1)) +
    colour = "black",  geom="line", aes(shape="total", group=1)) +
    guides(colour=guide_legend(order=1), shape=guide_legend(title=NULL, order=2))

#gave up on ggplot
#ggplot stat_summary one more try, googled by ggplot stat_summary line type and found a perfect link
#src http://stackoverflow.com/questions/17244921/ggplot2-when-i-use-stat-summary-with-line-and-point-geoms-i-get-a-double-legend
ggplot(dtfr, aes(x=Year, y=Value)) +
    geom_line(aes(group=Sector, color=Sector)) +
    geom_point(aes(color=Sector, shape=Sector)) +
    stat_summary(aes(colour="mean",shape="mean",group=1), fun.y=mean, geom="line", size=1.1) +
    scale_color_manual(values=c("#004E00", "#33FF00", "#FF9966", "#3399FF", "#FF004C")) +
    scale_shape_manual(values=c(1:4, 32)) +
    ggtitle("Test for ggplot2 graph")
#copying exactly with mean, to make sure it works
p3 <- ggplot(df.coal.summarized, aes(x=year, y=emissions.total)) +
    geom_line(aes(group=EI.Sector, color=EI.Sector)) + 
    geom_point(aes(color=EI.Sector, shape=EI.Sector)) + 
    stat_summary(aes(color="mean", group=1, shape="mean"), fun.y=mean, geom="line")
p3
#changing mean to sum - FINAL cut
#reference source on how to add total line
#http://stackoverflow.com/questions/17244921/ggplot2-when-i-use-stat-summary-with-line-and-point-geoms-i-get-a-double-legend
p4 <- ggplot(df.coal.summarized, aes(x=year, y=emissions.total)) +
    geom_line(aes(group=EI.Sector, color=EI.Sector)) + 
    geom_point(aes(color=EI.Sector, shape=EI.Sector)) + 
    stat_summary(aes(color="total",shape="total", group=1), fun.y=sum, geom="line", size=1.1) +
    #scale_color_manual(values=c( "#33FF00", "#FF9966", "#3399FF", "#FF004C")) +
    scale_color_manual(values=c( "green", "orange", "blue", "red")) +
    scale_shape_manual(values=c(1:3,32)) +
    ggtitle("U.S. emissions from coal combustion-related sources from 1999–2008")
p4
    
### Step 4. Create .png file
dev.copy(png, file = "plot4.png", width=900, height=600 ) 
dev.off()


### previous code - didn't break down by EI.Sector
#Q4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
#explore SCC dataset
names(SCC)
head(SCC)
str(SCC)
summary(SCC)
SCC[SCC$SCC=="10100217",] #looks like unique values, no composite key?
NEI[NEI$SCC=="10100217",] #matches - all data of type Point
#find coal-combustion related
SCC[grep("[Cc]oal",SCC$Short.Name),]$Short.Name
#hint from discussion forum on what coal-combustion related means
unique(SCC$EI.Sector)
unique(SCC[grep("[Cc]oal",SCC$EI.Sector),]$EI.Sector) #gives only 3 values
#from discussion forums, great source
#src http://www.epa.gov/air/emissions/basic.htm
#TA suggestion on grep here
grep("^fuel comb -(.*)- coal$", SCC$EI.Sector, ignore.case=T)

#ready to get coal-combustion related sources from SCC and merge with NEI dataset 
scc.source.coalcombustion<-SCC[grep("[Cc]omb (.*) [Cc]oal",SCC$EI.Sector), ]$SCC
unique(scc.source.coalcombustion)
#on the second thought, no need to merge, only need to pick out of NEI where scc=scc.source.coalcombustion
#use dplyr
#still need df<-tbl_df(NEI)
df.coal.related<-filter(df,SCC %in% scc.source.coalcombustion) #$ac verify by grep or smth else
df.coal.grouped<-group_by(df.coal.related,year)
df.coal.summarized<-summarize(df.coal.grouped, count=n(), emissions.total=sum(Emissions))
head(df.coal.summarized)  
p<-ggplot(df.coal.summarized,aes(x=df.coal.summarized$year,y=df.coal.summarized$emissions.total))
p+geom_point()

#Q5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
#hint from discussion forum on what motor vehichle related means
unique(SCC$EI.Sector)
unique(SCC[grep("[Vv]ehicle",SCC$EI.Sector),]$EI.Sector) #gives only 4 values, all seem fine
scc.source.motorvehicle<-SCC[grep("[Vv]ehicle",SCC$EI.Sector), ]$SCC
View(SCC[grep("[Vv]ehicle",SCC$EI.Sector), ]) #confirm data selected looks valid


df.Baltimore.motorvehicle.related<-filter(df,SCC %in% scc.source.motorvehicle, fips=="24510")
df.Baltimore.motorvehicle.grouped<-group_by(df.Baltimore.motorvehicle.related,year)
df.Baltimore.motorvehicle.summarized<-summarize(df.Baltimore.motorvehicle.grouped,count=n(), emissions.total=sum(Emissions))
p<-ggplot(df.Baltimore.motorvehicle.summarized,aes(x=year,y=emissions.total))
p+geom_point()

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

