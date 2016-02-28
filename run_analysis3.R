# Getting and unzipping the data
setwd("C:\Users\Cookie\Documents\Data Science\Module 3 Getting & Cleaning Data\Week4")
if(!file.exists("./Projdata")){dir.create("./Projdata")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Projdata/Dataset.zip")

unzip(zipfile="./Projdata/Dataset.zip",exdir="./Projdata")

path_Projdata <- file.path("./Projdata" , "UCI HAR Dataset")
Projdatafiles<-list.files(path_Projdata, recursive=TRUE)
Projdatafiles #check unzipped data


# Library packages required
library(plyr)

# Set working directory
setwd('C:/Users/Cookie/Documents/Data Science/Module 3 Getting & Cleaning Data/Week4/Projdata/UCI HAR Dataset')


# Task 1 - Merge the training and test sets to create one data set

Feature_train <- read.table("train/X_train.txt")
Activity_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

Feature_test <- read.table("test/X_test.txt")
Activity_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# create 'Activity' data set
Activity_data <- rbind(Feature_train, Feature_test)

# create 'Features' data set
Feature_data <- rbind(Activity_train, Activity_test)

# create 'subject' data set
Subject_data <- rbind(subject_train, subject_test)


# Task 2 - Extract mean and standard deviation for each measurement from dataset above

features <- read.table("features.txt")

# get only columns with mean() or std() in their names
meanstd <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
Activity_data <- Activity_data[, meanstd]

# correct the column names
names(Activity_data) <- features[meanstd, 2]

# Task 3 Use descriptive activity names to name the activities

activities <- read.table("activity_labels.txt")

# update values with correct activity names
Feature_data[, 1] <- activities[Feature_data[, 1], 2]

# correct column name
names(Feature_data) <- "activity"

# Step 4 -  Appropriately label the data set with descriptive variable names

# correct column name
names(Subject_data) <- "subject"

# bind all the data in a single data set
Merge_data <- cbind(Feature_data, Activity_data, Subject_data)

# Task 5 - Create a second, independent tidy data set with the average of each variable
# for each activity and each subject

clean_data <- ddply(Merge_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(clean_data, "clean_data.txt", row.name=FALSE)