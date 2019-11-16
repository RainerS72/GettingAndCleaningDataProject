# Getting And Cleaning Data Project
## How the script "run_analysis.R" works :
1. Library dplyr is loaded for later data manipulation
2. ZIP file is loaded from provided URL and afterwards extracted
3. content of files is red to data.frames:
+  features.txt  ==>   var_names
+  X_test        ==>   x_test
+  y_test        ==>   y_test
+  x_train       ==>   x_train
+  y_train       ==>   y_train
+  subject_test  ==>   s_test
+  subject_train ==>   s_train
4. merging data is done with frames x, y and s (for both test and train sets)
5. out of merged data we prepare new data.frame "mean_std_measurement" with only "mean" and "std" measurements
6. After this we create descriptive activity names
7. as next we create more descriptive field names using gsub
8. finaly creating a TidyDataSet with averages and writing it down to file "TidyDataSet.txt"
