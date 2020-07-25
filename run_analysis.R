## Previous steps
## 1. Checking if file already exists

if (!file.exists("project.zip")){
        +     fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        +     download.file(fileURL, "project.zip")
        }  

## 2. Checking if folder exists

if (!file.exists("UCI HAR Dataset")) { 
        +     unzip("project.zip") 
        }

## 3. Assigning data frames

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")


## Assignment steps
## Step 1: Merges the training and the test sets to create one data set.

# concatenate the individual data tables appropriately
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
joindata <- cbind(subject, y, x)


## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

joindata2 <- joindata %>% select(subject, code, contains("mean"), contains("std"))

## Step 3: Uses descriptive activity names to name the activities in the data set.

joindata2$code <- activities[joindata2$code, 2]


## Step 4: Appropriately labels the data set with descriptive variable names.

# Remove special characters
names(joindata2) <- gsub("[\\(\\)-]", "", names(joindata2))

# Assign descriptive names
names(joindata2)[2] <- "activity"
names(joindata2) <- gsub("Acc", "Accelerometer", names(joindata2))
names(joindata2) <- gsub("Gyro", "Gyroscope", names(joindata2))
names(joindata2) <- gsub("BodyBody", "Body", names(joindata2))
names(joindata2) <- gsub("Mag", "Magnitude", names(joindata2))
names(joindata2) <- gsub("^t", "TimeDomain", names(joindata2))
names(joindata2) <- gsub("^f", "FrequencyDomain", names(joindata2))
names(joindata2) <- gsub("tBody", "TimeBody", names(joindata2))
names(joindata2) <- gsub("mean", "Mean", names(joindata2))
names(joindata2) <- gsub("std", "StandardDeviation", names(joindata2))
names(joindata2) <- gsub("angle", "Angle", names(joindata2))
names(joindata2) <- gsub("gravity", "Gravity", names(joindata2))

# Remove the dots as a special character at the end of the names
names(joindata2) <- gsub("[\\(\\.)]+$", "", names(joindata2))


## Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## group by subject and activity and summarise using mean
tidyHDA_Data <- joindata2 %>% group_by(subject, activity) %>% summarise_all(.funs = mean)

# output to file with tidy data "HDA_Data_Means.txt"
write.table(tidyHDA_Data, "tidyHDA_Data.txt", row.names = FALSE, quote = FALSE)

