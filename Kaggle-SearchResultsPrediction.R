###################################################
## Author:Miztiik
## Source Inspiration :
## Date : 18May2015 01:06
## GitHub : https://github.com/miztiik/Kaggle-CrowdFlowerSearchResultsPrediction
##
## File : Kaggle - CrowdFlower Search Results Prediction
## URL : https://www.kaggle.com/c/crowdflower-search-relevance
## Inspiration : https://www.google.co.in/?q=mapping+user+search+queries+to+categories & http://www.asis.org/asist2011/proceedings/submissions/111_FINAL_SUBMISSION.pdf
###################################################

## About the challenge
## The challenge in this competition is to predict the relevance score(search term ~ given the product description and product title)
## Segmenting & clustering (any commonalities among the different keyword groups? How so? Graph the data; analyze the data.)
## Labeling these segmented keywords & keyword groups with search intents (assigning keyword intent into categories like: "transaction-oriented query", "commercial informational query" "non-commercial investigation query")

## The description field of products isthe most useful
## ** differentiating be-tween product and non-product queries or ambiguous queries. IF a query is not product based it should not be mapped to a product.
## ** detecting the relevant categories for a given query
## ** A third challenge is rank-ing the product categories for any given query.
## ** each query needs to have one more attribute telling whether to use it do product description search or ngram product description search or search prodcut names or ngram product name search

## ** one product per document








-- Y3hM3r@K3yH@!!!

query intent classification problem



how to split into subset while keep the distribution of (1,2,3,4) median ratings same among all subsets

use - Markov random walk algorithm to find probability for match in the title/description
IF markov doesn't work, do explicit semantic analysis
- can we use synonyms?
- TFIDF scheme
- KNN ( K nearest neighbour)


OKAPI BM25 is a bag-of-words retrieval function that ranks a set of documents based on the query terms appearing in each document.
-The given text fragment is first represented as a vector of words weighted also by TFIDF
--(supervised or un-supervised machine learning)
-- detecting noun phrases and named entities
---finding accurate weights on query terms and predicting which of the query terms are very important for the user'











## Cleaning up the environment variables
rm(list = ls(all = TRUE))
gc()

readData <- function() {
  require("readr")
  envir = globalenv()
  setwd("C:/Users/IBM_ADMIN/Desktop/R/Datasets/Kaggle/Kaggle-SearchResultsPrediction/")
  print("## Begin importing & preparing the data ##")
  ## Importing & Preparing the data ( using readr package faster than read.csv)
  dfTrain = read_csv("./input/train.csv")
  dfTest = read_csv("./input/test.csv")

  train_median_relevance = dfTrain$median_relevance
  train_relevance_variance = dfTrain$relevance_variance
  testID = dfTest$id

  ## Removing columns which are not necessary for the predictions
  dfTrain$median_relevance = NULL
  dfTrain$relevance_variance = NULL
  dfTrain$id = NULL
  dfTest$id = NULL

  ##Combining the dataset to make them ready for text analysis
  df = rbind(dfTrain,dfTest)

  assign("dfTrain", dfTrain, envir)
  assign("dfTest", dfTest, envir)
  assign("df",df,envir)
  assign("train_median_relevance",train_median_relevance,envir)
  assign("train_relevance_variance",train_relevance_variance,envir)


    print("## Finished importing & preparing the data ##")
}
readData()

## Creating Feature variables

## Query Length - All Shorter queries are more likedly to be important
require("qdap")
require("qdapTools")

df$queryLen = word_count(df$query, byrow = TRUE, missing = NA, digit.remove = FALSE, names = FALSE)

## Character Count Ratio:
## This is the number of characters in a term divided by the total number characters except white spaces in a query.
## Sometimes longer terms tend to imply multiple meanings to be more important in a query. This also accounts for spacing errors in writing queries
## http://www.inside-r.org/packages/cran/qdap/docs/word.count


charCount = character_count(df$query, byrow = TRUE, missing = NA, apostrophe.remove = TRUE, digit.remove = FALSE,count.space = FALSE)
charCountWSpace = character_count(df$query, byrow = TRUE, missing = NA, apostrophe.remove = TRUE, digit.remove = FALSE,count.space = TRUE)
df$ccRatio = charCount / charCountWSpace
#Probably can think of making ccRatio into three factore variables( Factor 1 : <0.85, Factor 2 : >=0.85 to <=0.95 , Factor 3 : >0.95

## Single Term Query Ratio:
## We also measure how important a term is by seeing how often it appears by itself as a search term in the list of search queries.
## We divide the number of occurrences of a term as a whole query by the number of queries that have the term among other terms so as to obtain a normalized value for the feature.

library("foreach")

singTerm = data.frame(table((df$query[df$ccRatio==1])))
singTerm$countInOthers = 0
foreach(i = 1:nrow(singTerm)) %do% {
	singTerm$countInOthers[i]= sum(grepl(singTerm$Var1[i],df$query,ignore.case=T))
	singTerm$Ratio[i] = (singTerm$Freq[i] / singTerm$countInOthers[i])

		df$singTermRatio[df$query==singTerm$Var1[i] & df$ccRatio==1]= singTerm$Ratio[i]
}
#remove all na
df$singTermRatio[is.na(df$singTermRatio)] = 0


