# Load packages
library(shiny)
library(data.table)
library(stylo)
library(ggplot2)

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

  output$prediction_plot <- renderPlot({
    data <- PredictionTable()[1:20]
    plot <- ggplot(data, aes(x=reorder(WORD,-P), y=P, fill=P)) +
              geom_bar(stat='identity', alpha=0.9) +
              theme(axis.text.x = element_text(angle = 60, hjust = 1, size=15)) +
              theme(axis.title = element_text(size=20)) +
              theme(axis.title.y = element_text(vjust=2)) +
              theme(legend.position='none') +
              labs(y = "Probability") +
              labs(x = "Word")
    plot
  })
  
  }
)