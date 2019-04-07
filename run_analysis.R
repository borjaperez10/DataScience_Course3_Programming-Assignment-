
#LOAD THE DATA
setwd("C:/Users/Borja/Documents/Workspace coursera/3-Getting_And_Cleaning_Data/Week4/Final Project")
library(data.table)
position <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE, sep=" ", header= FALSE)
features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt",stringsAsFactors = FALSE, header= FALSE, sep="\n")
features <- features[,1]
position <- position[,2]
features <- substr(features, regexpr(' ', features)+1, nchar(features))


trainingX <- data.frame(read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt"))
trainingY <- data.frame(read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt"))
trainingSubject <- data.frame(read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt"))

testingX <- data.frame(read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt"))
testingY <- data.frame(read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt"))
testingSubject <- data.frame(read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt"))



#1.- MERGES THE TESTING AND TRAINING DATA SETS
training <-  data.frame(trainingSubject, trainingX, trainingY)
testing <-  data.frame(testingSubject, testingX, testingY)

colnames(testing)[1] <- "subject"
colnames(testing)[2:562] <- features
colnames(testing)[563] <- "position"

colnames(training)[1] <- "subject"
colnames(training)[2:562] <- features
colnames(training)[563] <- "position"


#3.- Uses descriptive activity names to name the activities in the data set
testing$position <- factor(testing$position, labels = position)
training$position <- factor(training$position, labels = position)


#2.- Extracts only the measurements on the mean and standard deviation for each measurement.
#It will also add the columns subject and position
meanTraining <- training[,grep('\\b-mean()\\b', colnames(training))]
meanTesting <- testing[,grep('\\b-mean()\\b', colnames(testing))]
stdTraining <- training[,grep('\\b-std()\\b', colnames(training))]
stdTesting <- testing[,grep('\\b-std()\\b', colnames(testing))]

#4.-Appropriately labels the data set with descriptive variable names.
trainingMeanAndStd <-  data.frame(subject = training$subject, position = training$position, meanTraining, stdTraining)
testingMeanAndStd <-  data.frame(subject = testing$subject, position = testing$position,meanTesting, stdTesting)

#4.- From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

#create table:MEASURED TITLE        SUBJECT   WALKING  UPSTAIRS  DOWNSTAIRS  SITTING  STANDING   LAYING
#             tbodyAcc Mean (x)        1
#             tbodyAcc Mean (y)        1
#             tbodyAcc Mean (z)        1
#             tGravityyAcc Mean (x)

calculateAVGForSubjectTesting <- function(subj){
  print(subj)
  new <- testingMeanAndStd[1,]
  total <- testingMeanAndStd[1,]
  condition0 <- testingMeanAndStd$subject == subj
  i <- 1
  while(i<7){

    condition1 <- testingMeanAndStd$position == position[i]
    test1 <- testingMeanAndStd[(condition0 & condition1),]
    test2 <- testingMeanAndStd[(condition0 ),]
    test3 <- testingMeanAndStd[(condition1),]
    avg <- colMeans(test1[3:68])
    new[3:68] <- avg
  
    
    new[1] <- subj
    new[2] <- position[i]
    if(i == 1){
      total <- new
    }else{
      total <- rbind(new, total)
    }
    i<-i+1
  }
  total
}
calculateAVGForSubjectTraining <- function(subj){
  print(subj)
  new <- trainingMeanAndStd[1,]
  total <- trainingMeanAndStd[1,]
  condition0 <- trainingMeanAndStd$subject == subj
  i <- 1
  while(i<7){
    
    condition1 <- trainingMeanAndStd$position == position[i]
    test1 <- trainingMeanAndStd[(condition0 & condition1),]
    test2 <- trainingMeanAndStd[(condition0 ),]
    test3 <- trainingMeanAndStd[(condition1),]
    avg <- colMeans(test1[3:68])
    new[3:68] <- avg
    
    
    new[1] <- subj
    new[2] <- position[i]
    if(i == 1){
      total <- new
    }else{
      total <- rbind(new, total)
    }
    i<-i+1
  }
  total
}
x_test<-lapply(unique(testingMeanAndStd$subject), calculateAVGForSubjectTesting)
x_train<-lapply(unique(trainingMeanAndStd$subject), calculateAVGForSubjectTraining)
total_testing <- x_test[[1]]
total_training <- x_train[[1]]
i <- 2

while(i <= length(x_test)){
  total_testing <- rbind(x_test[[i]], total_testing)
  i <- i+1
}
i <- 2
while(i <= length(x_train)){
  total_training <- rbind(x_train[[i]], total_training)
  i <- i+1
}

#FOR VIEWING TESTING OF PATIENTS 2 AND 4 (6 variables)
total_testing[44:54, 1:6]
#FOR VIEWING TRAINING OF PATIENTS 30  (6 variables)
total_training[1:6, 1:6]

total <- rbind(total_training, total_testing)

write.table(total, row.names = FALSE, file = "total_training_and_testing_MEANSTD.txt")
write.table(total_training, row.names = FALSE, file = "trainingMEANSTD.txt")
write.table(total_testing, row.names = FALSE, file = "testingMEANSTD.txt")
