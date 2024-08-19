## Getting and Cleaning Data - peer assessment project


## Data download and variable assignment

a. The data was downloaded from:
 
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

  The files were extracted and saved in a folder named UCI HAR Dataset

b.the variables have been assigned as follows:

activity_labels<- read.table("activity_labels.txt", col.names= c("label","activity"))
features<- read.table("features.txt", col.names= c("code","features"))
subject_test<- read.table("subject_test.txt", col.names= "subject")
X_test<- read.table("X_test.txt", col.names= features$features)
y_test<- read.table("y_test.txt", col.names= "label")
subject_train<- read.table("subject_train.txt", col.names= "subject")
X_train<- read.table("X_train.txt", col.names= features$features)
y_train<- read.table("y_train.txt", col.names= "label")

## Project

# 1. Merging the training and the test sets to create one data set.

X<- rbind(X_test, X_train)
y<- rbind(y_test, y_train)
subject<- rbind(subject_test, subject_train)
data_set<- cbind(subject, y, X)

# 2. Extracting only the measurements on the mean and standard deviation for each measurement. 

I selected the columns that contains in the name the word "mean" or "std", together with the "subject" and the "label columns.

mean_std<- data_set %>% select("subject", "label", contains("mean"), contains("std"))

# 3. Using descriptive activity names to name the activities in the data set
 
First I created a new columns corresoponding to the descriptive names of the activities and labelled it "activity", then I removed the "label" column and reordered the columns, so that "activity" comes after "subject"

table_activities<- mean_std %>% merge(activity_labels, by="label") %>% select(-(label))%>%relocate("activity", .after="subject")

# 4. Appropriately labeling the data set with descriptive activity names. 
I subsituted the abbreviation with the complete name with the command gsub()
 
"^t" = "Time"
"^f" = "Frequency"
"Acc" = "Accelerometer"
"Gyro" = "Gyroscope"
"BodyBody"= "Body"
"tbody" = "TimeBody"
"Mag"=  "Magnitude"
"angle" = "Angle"
".mean" = "Mean"
".std"= "STD"
".freq" = "Frequency"
"gravity" = "Gravity"


# 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject. 

I grouped the data by subject and activity and generate the mean

final_data<- table_activities %>% group_by(subject, activity) %>% summarise_all(mean)

## Save final_data

write.table(final_data, "final_data.txt", row.names = F, col.names= T, sep = "\t")


