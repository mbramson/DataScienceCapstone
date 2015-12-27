# Load packages
library(shiny)
library(tm)

# Load the source data
con <- file("en_US.twitter.txt", "r")
tweets <- readLines(con, 2360148)
close(con)

# Output
shinyServer(function(input,output) {
  

  }
)