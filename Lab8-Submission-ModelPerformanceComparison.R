# Consider a library as the location where packages are stored.
# Execute the following command to list all the libraries available in your
# computer:
.libPaths()

# One of the libraries should be a folder inside the project if you are using
# renv

# Then execute the following command to see which packages are available in
# each library:
lapply(.libPaths(), list.files)



if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# STEP 1. Install and Load the Required Packages ----
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## kernlab ----
if (require("kernlab")) {
  require("kernlab")
} else {
  install.packages("kernlab", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## randomForest ----
if (require("randomForest")) {
  require("randomForest")
} else {
  install.packages("randomForest", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## naniar ----
if (require("naniar")) {
  require("naniar")
} else {
  install.packages("naniar", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# STEP 2. Load the Dataset ----
data("BreastCancer")

# STEP 3. Check for Missing Data and Address it ----

# Are there missing values in the dataset?
any_na(BreastCancer)

# How many?
n_miss(BreastCancer)

# What is the proportion of missing data in the entire dataset?
prop_miss(BreastCancer)

# What is the number and percentage of missing values grouped by
# each variable?
miss_var_summary(BreastCancer)

# Which variables contain the most missing values?
gg_miss_var(BreastCancer)


## OPTION 2: Remove the variables with missing values ----
BreastCancer_removed_vars <-
  BreastCancer %>%
  dplyr::select(- Bare.nuclei)

# The initial dataset had 699 observations and 11 variables
dim(BreastCancer)

# The filtered dataset has 15007 observations and 10 variables
dim(BreastCancer_removed_vars)

# Are there missing values in the dataset?
any_na(BreastCancer_removed_vars)


# STEP 4. The Resamples Function ----

## 4.a. Train the Models ----
# We train the following models, all of which are using 10-fold repeated cross
# validation with 3 repeats:
#   LDA
#   CART
#   KNN
#   SVM
#   Random Forest


train_control <- trainControl(method = "repeatedcv", number = 10, repeats = 3)


### LDA ----
set.seed(7)
BreastCancerModel_lda <- train(Class ~ ., data = BreastCancer_removed_vars,
                               method = "lda", trControl = train_control)


### CART ----
set.seed(7)
BreastCancerModel_cart <- train(Class ~ ., data = BreastCancer_removed_vars,
                                method = "rpart", trControl = train_control)

### KNN ----
set.seed(7)
BreastCancerModel_knn <- train(Class ~ ., data = BreastCancer_removed_vars,
                               method = "knn", trControl = train_control)

### SVM ----
set.seed(7)
BreastCancerModel_svm <- train(Class ~ ., data = BreastCancer_removed_vars,
                               method = "svmRadial", trControl = train_control)


### Random Forest ----
set.seed(7)
BreastCancerModel_rf <- train(Class ~ ., data = BreastCancer_removed_vars,
                              method = "rf", trControl = train_control)


## 4.b. Call the `resamples` Function ----
# We then create a list of the model results and pass the list as an argument
# to the `resamples` function.

results <- resamples(list(LDA = BreastCancerModel_lda, 
                          CART = BreastCancerModel_cart,
                          KNN = BreastCancerModel_knn, 
                          SVM = BreastCancerModel_svm,
                          RF = BreastCancerModel_rf))




