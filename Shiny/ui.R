library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("N-Gram Word Prediction"),
  
  sidebarPanel(
    
    textInput("text_input", "Text Input:", value = ""),
    submitButton('Submit')
    
  ),
  
  mainPanel(
    tabsetPanel(type="tabs",
      tabPanel("Prediction",
        h3("Word Prediction"),
        verbatimTextOutput("predicted_word")
      ),
      tabPanel("Table",
        h3("Predicted Words Ranked by Probability"),
        dataTableOutput('prediction_table')),
      tabPanel("Plot",
        h3("Plot of Predicted Words"),
        plotOutput("prediction_plot"))
    )
  )
  
  )
)
