By running the script you will be able to:

1.-Load the data available (it must be placed on the Workspace)
2.-Merge all the data: you will have two available datasets: one for training, second one for testing

	Description of the data:
		Training data: 7352 obs of 563 variables. 
			First variable is the Subject ID.
			Last variable is the position where the subject was (sitting, laying, walking...)
			All other variables description can be found in the features.txt file.
			
		Testing data: 2947 obs of 563 variables. 
			First variable is the Subject ID.
			Last variable is the position where the subject was (sitting, laying, walking...)
			All other variables description can be found in the features.txt file.
			
3.-Then, only the measurements on the mean and standard deviation for each measurement were extracted. 
The subject and position columns were also saved in this new variables, called trainingMeanSTD and testingMeanSTD.
For these variables, the labels were appropiately set with correct variable names.

4.-Finally, using this two datasets, two independent tidy data sets were created.
Each one with the average of each variable for each activity and each subject.
In total, we have three datasets:

TRAINING TOTAL DATASET (total_training variable name)
	54 obs of 68 variables. 
	First variable is the subject.
	Second variable is the position
	Other variables are the average value for each subject each position.
	For example, patient number 2, has different average values for sitting position, walking, laying...
TESTING TOTAL DATASET (total_testing variable name)
	126 obs of 68 variables. 
	First variable is the subject.
	Second variable is the position
	Other variables are the average value for each subject each position.
	For example, patient number 30, has different average values for sitting position, walking, laying...
TOTAL DATASET (total variable name), which is the sum of both of them
	The sum of both of them.
	In total there are 180 obs of 68 variables.
	30 subjects x 6 positions = 180 combinations