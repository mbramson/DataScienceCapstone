# Load packages
library(shiny)
library(quanteda)

# Load Corpora
tweet.con <- file("en_US.twitter.txt")
tweet.corpus <- corpus(readLines(tweet.con))
close(tweet.con)

blog.con <- file("en_US.blogs.txt")
blog.corpus <- corpus(readLines(blog.con))
close(blog.con)

news.con <- file("en_US.news.txt", open="rb")
news.corpus <- corpus(readLines(news.con, encoding="UTF-8"))
close(news.con)

# Output
shinyServer(function(input,output) {
  

  }
)