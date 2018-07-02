## Download and unzip the dataset:
library(reshape2)
library(rJava)
library(xlsx) ## lOADING THE PACKAGE we'll need
loc.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
tf <- 'C:/Users/Tommy/Documents/John Hopkins school/Getting and cleaning the data/Homework/dataset.zip'
download.file(loc.url, tf) ##dowloading the file
UCI_HAR_Dataset <- unzip(tf, list=TRUE)$Name[1:32] ##read all the files in the zip folder 
unzip(tf, files=UCI_HAR_Dataset,
      exdir='C:/Users/Tommy/Documents/John Hopkins school/Getting and cleaning the data/Homework', overwrite=TRUE)
## Features and Labels
activity_labels <- read.table(unzip(tf, list=TRUE)$Name[1])
activity_labels [,2] <- as.character(activity_labels[,2]) ## removing the duplicate column
colnames(activity_labels ) <- c("activityId", "activityLabel")
Features_labels <- read.table(unzip(tf, list=TRUE)$Name[2], as.is = TRUE)
Features_labels  [,2] <- as.character(Features_labels [,2])


## Read training data
Training_values<- read.table(unzip(tf, list=TRUE)$Name[31]) ## unzipping the train file
Training_subjects <- read.table(unzip(tf, list=TRUE)$Name[30])
Training_activity <- read.table(unzip(tf, list=TRUE)$Name[32])
training <- cbind(Training_subjects,Training_activity,Training_values)
##read Test data
Test_values<- read.table(unzip(tf, list=TRUE)$Name[17]) ## unzipping the train file
Test_subjects <- read.table(unzip(tf, list=TRUE)$Name[16])
Test_activity <- read.table(unzip(tf, list=TRUE)$Name[18])
test <- cbind(Test_subjects,Test_activity,Test_values)
## Merge both data
Human_Activity <- rbind(test,training)
colnames(Human_Activity) <- c('subject',"activity",Features_labels  [,2] )

## extract only mean amd standard deviation
features_wanted <- grepl(".*mean.*|.*std.*", Features_labels[,2])
features_wanted <- Features_labels[features_wanted , 2]
colnames(Human_Activity) <- c("subject", "activity", features_wanted)


##Appropriately labels the data set with descriptive variable names.
human_Activity_Cols <- colnames(Human_Activity)
human_Activity_Cols <- gsub("Acc", "Accelerometer", humanActivityCols)
human_Activity_Cols <- gsub("Gyro", "Gyroscope", humanActivityCols)
human_Activity_Cols <- gsub("Mag", "Magnitude", humanActivityCols)
human_Activity_Cols <- gsub("Freq", "Frequency", humanActivityCols)
human_Activity_Cols <- gsub("mean", "Mean", humanActivityCols)
human_Activity_Cols <- gsub("std", "StandardDeviation", humanActivityCols)

## create independent tidy data set with the average  
Human_Activity$activity <- factor(Human_Activity$activity, levels = activity_labels[,1], labels = activity_labels[,2])
Human_Activity$subject <- as.factor(Human_Activity$subject)

Human_Activity.melted<- melt(Human_Activity, id = c("subject", "activity"))
Human_Activity.mean <- dcast(Human_Activity.melted, subject + activity ~ variable, mean)
write.table(Human_Activity.mean, "tidy_data.txt", row.names = FALSE, 
            quote = FALSE)
