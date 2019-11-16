# lets load required packages
library(dplyr)

# Download and extract ZIP file from URL
fName <- "UCI_HAR_Dataset.zip"
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists(fName)){
    download.file(URL, destfile = fName, method = "curl") 
}
#Unzip the file (folder will be "UCI HAR Dataset)
unzip(fName)

# lets now read data from files into variables:
var_names <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","func"))
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = var_names$func)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = var_names$func)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
s_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
s_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")


# 1. Merges the training and the test sets to create one data set.
X_merged <- rbind(x_train, x_test)
Y_merged <- rbind(y_train, y_test)
S_merged <- rbind(s_train, s_test)
Merged_Data <- cbind(S_merged, Y_merged, X_merged)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std_measurement <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
mean_std_measurement$code <- act_labels[mean_std_measurement$code, 2]

# 4. Appropriately labels the data set with descriptive variable names.
names(mean_std_measurement)<-gsub("code","Action", names(mean_std_measurement))
names(mean_std_measurement)<-gsub("^t", "Time", names(mean_std_measurement))
names(mean_std_measurement)<-gsub("^f", "Frequency", names(mean_std_measurement))
names(mean_std_measurement)<-gsub("Acc", "Accelerometer", names(mean_std_measurement))
names(mean_std_measurement)<-gsub("Gyro", "Gyroscope", names(mean_std_measurement))
names(mean_std_measurement)<-gsub("BodyBody", "Body", names(mean_std_measurement))
names(mean_std_measurement)<-gsub("Mag", "Magnitude", names(mean_std_measurement))
names(mean_std_measurement)<-gsub("BodyBody", "TimeBody", names(mean_std_measurement))
names(mean_std_measurement)<-gsub("-std()", "STD", names(mean_std_measurement), ignore.case = TRUE)
names(mean_std_measurement)<-gsub("-mean()", "MEAN", names(mean_std_measurement), ignore.case = TRUE)
names(mean_std_measurement)<-gsub("-freq()", "Frequency", names(mean_std_measurement), ignore.case = TRUE)


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
TidyDataSet <- mean_std_measurement %>%
    group_by(subject, Action) %>%
    summarise_all(funs(mean))
write.table(TidyDataSet, "TidyDataSet.txt", row.name=FALSE)
