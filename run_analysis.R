# Merges the training and the test sets to create one data set.

# Read train folder files
x_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")

# Read test folder files
x_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")

#merge 
train_merge <- cbind(x_train, y_train, subject_train)
#dim(train_merge)
test_merge <- cbind(x_test, y_test, subject_test)
#dim(test_merge)
train_test_merge <- rbind(train_merge, test_merge)

# Extract only the measurement on mean and standard deviation
features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
col_names <- c(features[,2], "activity_id", "subject_id")

# Label the dataset variable name
names(train_test_merge) <- col_names
train_test_merge_mean_std <- train_test_merge[, grepl( "mean\\(\\)|std|activity_id|subject_id",names(train_test_merge))]

# Name the activity in the data set by mapping with id
activity_labels = read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("activity_id", "activity_name")
train_test_merge_mean_std <- merge(train_test_merge_mean_std,activity_labels,by="activity_id",all=TRUE)

# Get the tidy data set average for each activity and subject
tidy_set_mean <- aggregate(. ~activity_name+subject_id, train_test_merge_mean_std, FUN=mean) 

# write to the file
write.table(tidy_set_mean, "tidy.txt", row.name=FALSE)