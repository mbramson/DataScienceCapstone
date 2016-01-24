library(data.table)
library(stylo)

# Load the Source Data
load("./data/ngram_optimized.Rdata")

build_prediction_table <- function(text) {
  COLUMN_NAMES <- c("WORD", "N","P")

  t <- process_input_text(text)

  n_words <- length(t)

  if (n_words >= 5) {
    prediction_6 <- ng_6[J(t[1],t[2],t[3],t[4],t[5])][order(-N)][,6:7, with=FALSE]
    prediction_5 <- ng_5[J(t[2],t[3],t[4],t[5])][order(-N)][,5:6, with=FALSE]
    prediction_4 <- ng_4[J(t[3],t[4],t[5])][order(-N)][,4:5, with=FALSE]
    prediction_3 <- ng_3[J(t[4],t[5])][order(-N)][,3:4, with=FALSE]
    prediction_2 <- ng_2[J(t[5])][order(-N)][,2:3, with=FALSE]
    # Assign Probability
    prediction_6$P <- prediction_6$N / sum(prediction_6$N)
    prediction_5$P <- prediction_5$N / sum(prediction_5$N)
    prediction_4$P <- prediction_4$N / sum(prediction_4$N)
    prediction_3$P <- prediction_3$N / sum(prediction_3$N)
    prediction_2$P <- prediction_2$N / sum(prediction_2$N)
    # Set Column Names
    names(prediction_6) <- COLUMN_NAMES
    names(prediction_5) <- COLUMN_NAMES
    names(prediction_4) <- COLUMN_NAMES
    names(prediction_3) <- COLUMN_NAMES
    names(prediction_2) <- COLUMN_NAMES
    # Combine Predictions
    prediction_all <- rbind(prediction_6, prediction_5, prediction_4, prediction_3, prediction_2, ng_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
  } else if (n_words == 4) {
    prediction_5 <- ng_5[J(t[1],t[2],t[3],t[4])][order(-N)][,5:6, with=FALSE]
    prediction_4 <- ng_4[J(t[2],t[3],t[4])][order(-N)][,4:5, with=FALSE]
    prediction_3 <- ng_3[J(t[3],t[4])][order(-N)][,3:4, with=FALSE]
    prediction_2 <- ng_2[J(t[4])][order(-N)][,2:3, with=FALSE]
    # Assign Probability
    prediction_5$P <- prediction_5$N / sum(prediction_5$N)
    prediction_4$P <- prediction_4$N / sum(prediction_4$N)
    prediction_3$P <- prediction_3$N / sum(prediction_3$N)
    prediction_2$P <- prediction_2$N / sum(prediction_2$N)
    # Set Column Names
    names(prediction_5) <- COLUMN_NAMES
    names(prediction_4) <- COLUMN_NAMES
    names(prediction_3) <- COLUMN_NAMES
    names(prediction_2) <- COLUMN_NAMES
    # Combine Predictions
    prediction_all <- rbind(prediction_5, prediction_4, prediction_3, prediction_2, ng_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
  } else if (n_words == 3) {
    prediction_4 <- ng_4[J(t[1],t[2],t[3])][order(-N)][,4:5, with=FALSE]
    prediction_3 <- ng_3[J(t[2],t[3])][order(-N)][,3:4, with=FALSE]
    prediction_2 <- ng_2[J(t[3])][order(-N)][,2:3, with=FALSE]
    # Assign Probability
    prediction_4$P <- prediction_4$N / sum(prediction_4$N)
    prediction_3$P <- prediction_3$N / sum(prediction_3$N)
    prediction_2$P <- prediction_2$N / sum(prediction_2$N)
    # Set Column Names
    names(prediction_4) <- COLUMN_NAMES
    names(prediction_3) <- COLUMN_NAMES
    names(prediction_2) <- COLUMN_NAMES
    # Combine Predictions
    prediction_all <- rbind(prediction_4, prediction_3, prediction_2, ng_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
  } else if (n_words == 2) {
    prediction_3 <- ng_3[J(t[1],t[2])][order(-N)][,3:4, with=FALSE]
    prediction_2 <- ng_2[J(t[2])][order(-N)][,2:3, with=FALSE]
    # Assign Probability
    prediction_3$P <- prediction_3$N / sum(prediction_3$N)
    prediction_2$P <- prediction_2$N / sum(prediction_2$N)
    # Set Column Names
    names(prediction_3) <- COLUMN_NAMES
    names(prediction_2) <- COLUMN_NAMES
    # Combine Predictions
    prediction_all <- rbind(prediction_3, prediction_2, ng_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
  } else {
    prediction_2 <- ng_2[J(t[1])][order(-N)][,2:3, with=FALSE]
    # Assign Probability
    prediction_2$P <- prediction_2$N / sum(prediction_2$N)
    # Set Column Names
    names(prediction_2) <- COLUMN_NAMES
    # Combine Predictions
    prediction_all <- rbind(prediction_2, ng_1, fill=TRUE)[order(-P)][,c(1,3), with=FALSE]
    prediction <- prediction_all[,lapply(.SD,max),by="WORD"]
  }
  # If nothing matches so far, just return the top 100 single words
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