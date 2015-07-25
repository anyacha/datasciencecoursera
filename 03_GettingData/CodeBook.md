---
title: "Tidy Dataset CodeBook"
author: "Anya Chaliotis"
date: "July 24, 2015"
output: html_document
---

This file describes the dataset created by script run_analysis.R  

### Input

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

files used:

* features.txt: List of all features.
* activity_labels.txt: Links the class labels with their activity name.
* train/X_train.txt: Training set.
* train/y_train.txt: Training labels.
* test/X_test.txt: Test set.
* test/y_test.txt: Test labels.

### Transformations 

Script run_analysis.R performs the following data clean up and transformations: 

1. Merges the training and the test sets to create one data set.  
2. Extracts only the measurements on the mean and standard deviation for each measurement.  
3. Uses descriptive activity names to name the activities in the data set  
4. Appropriately labels the data set with descriptive variable names.  
5.  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

### Output 

a tidy dataset with the following columns:

* subject_id: 30 deidentified volunteers
* activity_label: 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
* variable: a list of measurements that deal with the mean and standard deviation of captured measurements
* variableAverage: aggregated mean of each variable (as specified above) by each subject and each activity.
