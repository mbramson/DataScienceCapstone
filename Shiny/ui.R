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
        verbatimTextOutput("predicted_word")
      ),
      tabPanel("Table",
        h2("Predicted Words Ranked by Probability"),
        dataTableOutput('prediction_table'))
    )
  )
  
  )
)
