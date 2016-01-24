library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("N-Gram World Prediction"),
  
  sidebarPanel(
    
    textInput("text_input", "Text Input:", value = ""),
    submitButton('Submit')
    
  ),
  
  mainPanel(
    tabsetPanel(type="tabs",
      tabPanel("Prediction",
        verbatimTextOutput("predicted_word")
      )
    )
  )
  
  )
)
