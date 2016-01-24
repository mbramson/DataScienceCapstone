# Load packages
library(shiny)
library(data.table)
library(stylo)

source("PredictionModel.R")

# Output
shinyServer(function(input,output) {
  
  PredictionTable <- reactive({
    build_prediction_table(input$text_input)
  })
  
  output$predicted_word <- renderText({
    PredictionTable()[1]$WORD
  })
  
  output$prediction_table <- renderDataTable({ 
    head(PredictionTable(), 10)
    }, options = list( pageLength = 10, paging = FALSE, searching = FALSE) )

  }
)