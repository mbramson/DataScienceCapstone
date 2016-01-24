library(data.table)
library(stylo)

# Load the Source Data
load("./data/ngram_optimized.Rdata")

build_prediction_table <- function(text) {
  COLUMN_NAMES <- c("WORD", "N","P")

  #This had better output 5 words
  t <- process_input_text(text)

  n_words <- length(t)

  # Default data.tables. Needed for cases when no matches are found and to aggregate all predictions
  Default.Table <- data.table(WORD=NA, N=NA, P=NA)
  prediction_6 <- Default.Table
  prediction_5 <- Default.Table
  prediction_4 <- Default.Table
  prediction_3 <- Default.Table
  prediction_2 <- Default.Table
  
  # Assign Probabilities
  if (n_words >= 5) {
    prediction_6 <- ng_6[J(t[n_words-4],t[n_words-3],t[n_words-2],t[n_words-1],t[n_words])][order(-N)][,6:7, with=FALSE]
    prediction_6$P <- prediction_6$N / sum(prediction_6$N)
    names(prediction_6) <- COLUMN_NAMES
  }
  if (n_words >= 4) {
    prediction_5 <- ng_5[J(t[n_words-3],t[n_words-2],t[n_words-1],t[n_words])][order(-N)][,5:6, with=FALSE]
    prediction_5$P <- prediction_5$N / sum(prediction_5$N)
    names(prediction_5) <- COLUMN_NAMES
  }
  if (n_words >= 3) {
    prediction_4 <- ng_4[J(t[n_words-2],t[n_words-1],t[n_words])][order(-N)][,4:5, with=FALSE]
    prediction_4$P <- prediction_4$N / sum(prediction_4$N)
    names(prediction_4) <- COLUMN_NAMES
  }
  if (n_words >= 2) {
    prediction_3 <- ng_3[J(t[n_words-1],t[n_words])][order(-N)][,3:4, with=FALSE]
    prediction_3$P <- prediction_3$N / sum(prediction_3$N)
    names(prediction_3) <- COLUMN_NAMES
  }
  if (n_words >= 1) {
    prediction_2 <- ng_2[J(t[n_words])][order(-N)][,2:3, with=FALSE]
    prediction_2$P <- prediction_2$N / sum(prediction_2$N)
    names(prediction_2) <- COLUMN_NAMES
  }
  
  # Combine Predictions
  prediction_all <- rbind(prediction_6, prediction_5, prediction_4, prediction_3, prediction_2, ng_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
  prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
  
  # If nothing was predicted just return the top 100 single words, ordered by probability
  if (is.na( prediction[1]$WORD )) {
    prediction <- ng_1[order(-P)]
  }
  
  # We only want valid predictions
  prediction <- prediction[complete.cases(prediction),]
  # return data.table with best matches
  return(prediction)
}

process_input_text <- function(input_text) {
  # process input text in the same way that we processed our training data using stylo
  text_split <- txt.to.words.ext(text, language="English.contr", preserve.case = FALSE)
  text_split <- gsub("\\^", "'", text)
  # If the number of words is > 5, only use the last 5 words.
  n_words <- length(text_split)
  if (n_words > 5) {
    return(text_split[(n_words-4):n_words])
    } else{ return(text_split) }
}