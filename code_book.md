## Code Book
This documents describes what data was used and what processing applied to create the resulting tidy data set.

### Data Source: 
Data was originally obtained from: 

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

specifically the following link was used to download the zip file: 

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

out of the zip file the following files where used

### Data description

Common: 

* `features.txt`: the names of the 561 features encoded in the data. (A full description can be found int the `features_info.txt` file in the archive)
* `activity_labels.txt`: map of id and names of the 6 activities.

Training Data: 

* `X_train.txt`: 7352 observations of the 561 features, for 21 of the 30 volunteers.
* `subject_train.txt`: A vector of 7352 integers, denoting a numeric identifier for the subject related to each of the observations in `X_train.txt`.
* `y_train.txt`: A vector of 7352 integers, denoting the identifier of the activity related to each of the observations in `X_train.txt`.

Test Data: 

* `X_test.txt`: 2947 observations of the 561 features, for 9 of the 30 volunteers.
* `subject_test.txt`: A vector of 2947 integers, denoting the ID of the volunteer related to each of the observations in `X_test.txt`.
* `y_test.txt`: A vector of 2947 integers, denoting the ID of the activity related to each of the observations in `X_test.txt`.

All other files of the archive were not used, specifically the 'Inertial Signals' data files.  

### Processing instructions

1. the `features.txt` files was read in as is, and restricted to its second column, to yield only the feature labels.
2. the `activity_labels.txt` file was read as is, and again restricted to the second column to yield a list of all activity names. 
3. the training data set was read from `subject_train.txt`, `X_train.txt` and `y_train.txt`
4. this data was then combined using the `mungeData` function. This function created a new data frame with the column names `subject`, `activity` followed by the feature names. It just concatenates the data of subject id,activity id and the feature data together. 
5. next the test data was read analog to 3. above reading from `subject_test.txt`, `X_test.txt` and `y_test.txt`. 
6. The test data was also combined using the `mungeData` function analog to 4. 
7. The rows of the combined test data set were appended to the combined training dataset
8. the average was calculated using the `aggregate` function applying the `mean` function to each of the features and activity. With that each  
9. the activities column was converted from the integer value to a factor using the activity names collected in step 2. 
10. the `tidy.csv` file is written out 