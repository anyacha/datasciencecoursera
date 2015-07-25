#Coursera, The "Data Science" Specialization
#course 03 Getting and Cleaning Data
#Anya Chaliotis
#7/24/2015
#Course project

#Project summary: this script
#- Merges the training and the test sets to create one data set.
#- Extracts only the measurements on the mean and standard deviation for each measurement. 
#- Uses descriptive activity names to name the activities in the data set
#- Appropriately labels the data set with descriptive variable names. 
#- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Step 0. setup
getwd()

### Step 1. Get raw data (check for existing data first)
#if no existing data, download and unpack zip files
if(!(file.exists("./UCI HAR Dataset/test") & file.exists("./UCI HAR Dataset/train"))){
    url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    destZip="./dataset.zip"
    download.file(url,destfile = destZip,method = "curl")
    unzip(destZip)
}
#else, assume the files already downloaded and unpacked.

### Step 2. Read and organize datasets
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activity_labels)<-c("activity_id","activity_label")
features<-read.table("UCI HAR Dataset/features.txt",header = F) #list of features 561

#train data set
train.subject<-read.table("./UCI HAR Dataset/train/subject_train.txt",header = F)
train.activity<-read.table("./UCI HAR Dataset/train/y_train.txt",header = F)
train.measurement<-read.table("./UCI HAR Dataset/train/X_train.txt",header = F)

#test data set
test.subject<-read.table("UCI HAR Dataset/test/subject_test.txt",header = F)
test.activity<-read.table("UCI HAR Dataset/test/y_test.txt",header = F)
test.measurement<-read.table("UCI HAR Dataset/test/X_test.txt",header = F)

#2b. Combine train and test sets
#2c. Label the combined dataset with descriptive variable names
set.subject<-rbind(train.subject,test.subject)
colnames(set.subject)="subject_id"
set.activity<-rbind(train.activity,test.activity)
colnames(set.activity)="activity_id"
set.measurement<-rbind(train.measurement,test.measurement)
set_colnames<-gsub("\\(|\\)", "",features$V2) #formatting: get rid of () in var names
set_colnames<-gsub("\\-",".",set_colnames) #formatting: replace - with .
colnames(set.measurement)<-set_colnames
#check for columns with missing values => no columns with missing values
any(is.na(set.measurement))
all(colSums(is.na(set.measurement))==0)

### Step 3. Create a subset with mean and std measurements only
set1<-set.measurement[,grep("\\.[Mm]ean|\\.[Ss]td",colnames(set.measurement))]
colnames(set1)

#clean up temp objects
rm(list=c("train.subject","train.activity","train.measurement","test.subject","test.activity","test.measurement"))

### Step 4. Combine 3 datasets into one: subject, activity, and measurements
set2<-cbind(set.subject,set.activity,set1)
str(set2)
colnames(set2) #validate column names

### Step 5. Use descriptive activity names to name the activities in the data set
#how: use plyr join, by activity_id columns
library(plyr)
set3<-join(set2,activity_labels)
set3[1:100,c("activity_id","activity_label")] #validate activity names

#clean up
rm(list=c("set1","set2","set.measurement","set.activity","set.subject"))

### Step 6. Reshape into narrow dataset
library(reshape2)
set.melt <-melt(set3,id=c("subject_id","activity_id", "activity_label"))
colnames(set.melt)

### Step 7.  Create independent tidy data set with the average of each variable 
# for each activity and each subject.
library(dplyr)
set.final<-select(set.melt,-activity_id)
set4<-tbl_df(set.final)
#consolidated (not step-by-step, but with pipe operator)
set.tidy <-
    set4 %>%
    group_by(subject_id,activity_label,variable) %>%
    summarize(variableAverage=mean(value)) %>%
    print

### Step 8. Create output file
?write.table
write.table(set.tidy,file="tidyDataset.txt",row.name=F)
    

### helpful code ###
#rm(list=ls())