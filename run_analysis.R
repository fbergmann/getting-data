# This function assumes that there is a test data set in the subfolder 
# `dataset` that set is just the extracted zip file as given in the task
# description. 
#

# for the processing we need a number of functions, that 
# will make the task easier. I just write them once, so that i 
# can use them over in other scripts

## renameColumn: this function is a basic function function
## for renaming columns of datasets
renameColumn <- function(data, oldName, newName) {
  # update those names in data that are 'oldName' to 
  # 'newName'
  names(data)[names(data) == oldName] <- newName
  
  #return the updated dataset
  data
}

## filterResult: filters the column names to the ones we need
filterResult <- function(columnNames)
{
  filter <- c()
  for (name in columnNames)
  {
    if (length(grep("(^subject$)|(^activity$)|(.mean)|(.std)", name)) > 0)
      filter <- c(filter, name)
  }
  filter
}


## mungeData: this function combines all the different results
## it will be used on both the training set as well as the test
## set to produce a similar format. 

mungeData <- function(
  features, 
  subjects, 
  measuredData, 
  measuredActivity)
{

  # create a new data frame
  result <- data.frame(subjects, measuredActivity, measuredData)
  
  # next we make the columns more descriptive:
  columnNames <- c ('subject', 'activity', features )
  columnNames <- make.names(columnNames)  
  colnames (result) <- columnNames;
  
  # restrict to the columns subject, mean, std, and activity
  result[filterResult(columnNames)]
}

# this function computes the averages needed 
calculateAverages <- function(appendedData)
{
  averages <- aggregate(appendedData, by=list(appendedData$subject, appendedData$activity), FUN=mean)
  cols <- colnames(averages)
  cols <- cols[cols != "activity" & cols != "subject"]
  averages <- averages[, cols]
  averages <- renameColumn(averages, "Group.1", "subject")
  averages <- renameColumn(averages, "Group.2", "activity")
  averages
}

## 1st read the features as is
features <- read.table("dataset/features.txt", as.is=TRUE)
# next restrict to v2
features <- features$V2

## 2nd read activities again as is
allActivities <- read.table("dataset/activity_labels.txt", as.is=TRUE)
# restrict to v2
allActivities <- allActivities$V2

## 3rd read training data and subjects each time
## we ignore the header
trainingSubjects <- read.table("dataset/train/subject_train.txt", header=FALSE)
trainingData <- read.table("dataset/train/X_train.txt", header=FALSE)
trainingActivities <- read.table("dataset/train/y_train.txt", header=FALSE)

## 4th munge training data together
mungedTrainingData <- mungeData(features, 
                               trainingSubjects, trainingData, trainingActivities)

## 5th we read the test data and subjects again ignoring the header
testSubjects <- read.table("dataset/test/subject_test.txt", header=FALSE)
testData <- read.table("dataset/test/X_test.txt", header=FALSE)
testActivities <- read.table("dataset/test/y_test.txt", header=FALSE)

# 6th munge the test data
#
mungedTestData <- mungeData(features, 
                            testSubjects, testData, testActivities)

# 7th append the test data rows to the training data rows
appendedData <- rbind(mungedTrainingData, mungedTestData)

# 8th: calculate averages
averages <- calculateAverages(appendedData)

# 9th: convert activity to factor
averages$activity <- factor(averages$activity, labels=allActivities)

# 10th: finally write tidy data
write.csv(averages, file='tidy.csv', row.names=FALSE)
