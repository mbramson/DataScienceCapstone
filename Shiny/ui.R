library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("N-Gram Word Prediction"),
  
  sidebarPanel(
    
    textInput("text_input", "Text Input:", value = ""),
    submitButton('Submit'),
    br(),
    h3("Instructions:"),
    p("1. Type a phrase into the Text Box"),
    p('2. Click the "Submit" button'),
    p("3. Select a tab to view prediction output")
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
