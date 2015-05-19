###################################################
## Author:Miztiik
## Source Inspiration :
## Date : 18May2015 01:06
## GitHub : https://github.com/miztiik/Kaggle-CrowdFlowerSearchResultsPrediction
##
## File : Kaggle - CrowdFlower Search Results Prediction
## URL : https://www.kaggle.com/c/crowdflower-search-relevance
###################################################

## About the challenge
## The challenge in this competition is to predict the relevance score(search term ~ given the product description and product title)

## Cleaning up the environment variables
rm(list = ls(all = TRUE))
gc()

readData <- function() {
  require("readr")
  envir = globalenv()
  setwd("C:/Users/IBM_ADMIN/Desktop/R/Datasets/Kaggle/Kaggle-SearchResultsPrediction/")
  print("## Begin importing & preparing the data ##")
  ## Importing & Preparing the data ( using readr package faster than read.csv)
  dfAllTrain = read_csv("./input/train.csv")
  dfAllTest = read_csv("./input/test.csv")

  testID = dfAllTest$id
  dfAllTrain$id = NULL
  dfAllTest$id = NULL

  assign("dfAllTrain", dfAllTrain, envir)
  assign("dfAllTest", dfAllTest, envir)
  
    print("## Finished importing & preparing the data ##")
}
readData()

