#Coursera, Johns Hopkins U, Data Sci, course #4 Exploratory Analysis
#Anya Chaliotis
#8/7/2015
#course project #1

#0. setup
rm(list=ls())
getwd()
setwd("~/Desktop/iSchool/Coursera/JohnsHopkinsU_DataScienceSpec/4ExploratoryDataAnalysis/assignments/CourseProject1")

### Step 1. Loading the data
# 1.1 Get raw data (check for existing data first)
#if no existing data, download and unpack zip files
if (!file.exists("./data")) {
    url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    destZip<-"household_power_consumption.zip"
    download.file(url,destfile = destZip, method="curl")
    dir.create("./data")
    unzip(destZip, exdir = "./data")
}
#else, assume the files already downloaded and unpacked.

#1.2 read in a subset
#figure out how many lines to skip => starts at line #66638, skip 66637
subset.first.rec <- min(grep("^[1|2]/2/2007", readLines("./data/household_power_consumption.txt"))) 
#figure out how many lines to read (assume data is ordered by date) => 2880
subset.num.of.records <- length(grep("^[1|2]/2/2007", readLines("./data/household_power_consumption.txt")))

df<- read.table("./data/household_power_consumption.txt", header = F, sep=";", 
     skip=subset.first.rec - 1, nrows=subset.num.of.records)
#get column names
df.col.names <-read.table("./data/household_power_consumption.txt", header = T, sep=";", nrows=1)
colnames(df) <- names(df.col.names)

#1.3  convert date fields to proper data types
df$Date<-as.Date(df$Date,format = "%e/%m/%Y")
df$datetime<-strptime(paste(df$Date,df$Time),"%Y-%m-%d %H:%M:%S")

### Step 2 Making Plots
#Plot 3
#diff colors for diff meters
par()
par(ps=12)
with(df, {
    plot(datetime,Sub_metering_1,type="l", xlab=NA, ylab="Energy sub metering")
    lines(datetime,Sub_metering_2,col="red",type="l") 
    lines(datetime, Sub_metering_3,col="blue", type="l") 
    legend("topright", lty=1, col = c("black", "red", "blue"), legend = paste0(colnames(df[7:9]),"  "), seg.len=1)
})
dev.copy(png, file = "plot3.png", width=480, height=480, units="px") ## Copy my plot to a PNG file
dev.off()


