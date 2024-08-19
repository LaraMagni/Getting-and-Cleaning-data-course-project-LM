Read the documents and assign name to the columns

library(dplyr)
activity_labels<- read.table("activity_labels.txt", col.names= c("label","activity"))
features<- read.table("features.txt", col.names= c("code","features"))
subject_test<- read.table("subject_test.txt", col.names= "subject")
X_test<- read.table("X_test.txt", col.names= features$features)
y_test<- read.table("y_test.txt", col.names= "label")
subject_train<- read.table("subject_train.txt", col.names= "subject")
X_train<- read.table("X_train.txt", col.names= features$features)
y_train<- read.table("y_train.txt", col.names= "label")


1. Merge the training and the test sets to create one data set

X<- rbind(X_test, X_train)
y<- rbind(y_test, y_train)
subject<- rbind(subject_test, subject_train)
data_set<- cbind(subject, y, X)


2. Ectract only the measurements on the mean and standard deviation for each measurement

mean_std<- data_set %>% select("subject", "label", contains("mean"), contains("std"))


3. Use descriptive activity names to name the activities in the dataset

table_activities<- mean_std %>% merge(activity_labels, by="label") %>% select(-(label))%>%relocate("activity", .after="subject")


4. Appropriately lable the data set with descriptive variable names

names(table_activities)<- gsub("^t", "Time",
gsub("^f", "Frequency",
gsub("Acc", "Accelerometer",
gsub("Gyro", "Gyroscope",
gsub("BodyBody", "Body",
gsub("tbody", "TimeBody",
gsub("Mag", "Magnitude",
gsub("angle", "Angle",
gsub(".mean", "Mean",
gsub(".std", "STD",
gsub(".freq", "Frequency",
gsub("gravity", "Gravity", names(table_activities))))))))))))))


5. From the data set in step 4, create a second, indipendent tidy data set with the average of each variable for each activity and each subject

final_data<- table_activities %>% group_by(subject, activity) %>% summarise_all(mean)

Save final_data
write.table(final_data, "final_data.txt", row.names = F, col.names= T, sep = "\t")
