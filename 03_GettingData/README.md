---
title: "README Instructions file"
author: "Anya Chaliotis"
date: "July 24, 2015"
output: html_document
---

This file provides instructions on how to work with script "run_analysis.R".  

The user can run the file in his/her R environment; the file will work in the user's working directory.  

### What this script does
This script downloads a zip file, unpacks the zip into individual data files, reads data from separate data files, combines data together, gets rid of unnecessary columns, reorgonizes the resulting data set into the narrow data format, and finally aggregates the results by specified dimensions.

### Step 1. Get raw data
The code checks for existing data in the user's working directory.  If data path doesn't exist, the script downloads and unzips the raw data file.  If data path already exists, the script presumes the data has been already downloaded and unpacked on the user's computer - the code continues working with the existing data files.  

* Data source
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

If the user prefers, it is possible to download raw data manually and bypass this automatic data setup. The user must ensure that the data gets successfully downloaded and unpacked in his/her working directory.  Further steps dependend on the existence of the right paths and data files.

### Step 2. Read data files and organize datasets
The script reads data from multiple files and combines data together.

This script is configured to work with the UCI HAR Dataset.zip.  Folder paths and data file names are hardcoded.  Without the right names, the code will not run.  If you need to work with some other data, please modify the code to reflect the paths and file names to reflect naming in your dataset.  
 
### Step 3. Create a subset 
The script select columns with mean and std measurements only.

### Step 4. Combine 3 datasets into one
Now the script takes 3 datasets: subject, activity, and measurements, and combines them into one for further processing.

### Step 5. Add descriptive data
The script merges the main dataset activity ids with descriptive activity names, which provides more readable data. 

### Step 6. Reshape data
The script "melts" wide data into narrow format: now all the measurements, that previously lived together in one row, will have a row of their own.

### Step 7. Create independent tidy data set
Finally, the dataset will be aggregated by certain criteria and provide the average of each variable 

### Step 8. Create output file
The output file will contain the newly formatted tidy data set.

### Dependencies: Packages Required
This script relies on the following packages:

* library(plyr)
* library(dplyr)
* library(reshape2)