library(shiny)

shinyUI(fluidPage(
  titlePanel("Text prediction demonstration"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("searchTerm", "Search text"),
      p("This is a fairly simple text prediction algorithm.  I have taken the provided data sources (Twitter, News, and Blog feeds from a few days) and performed a direct ngram frequency count."),
      p("The code can all be found at:"),
      a("https://github.com/crispaSLHS/textPrediction",href="https://github.com/crispaSLHS/textPrediction"),
      p("See the rpubs presentation for some more details."),
      a("http://rpubs.com/crispa/TextPrediction", href="http://rpubs.com/crispa/TextPrediction"),
      p("Feedback can be sent to andrew.crisp@gmail.com.")
    ),    
    mainPanel(
      textOutput("warningText"),
      h3(textOutput("searchTermLabel")),
      h3(textOutput("mostLikelyLabel")),
      DT::dataTableOutput("textPrediction")
    )
  )
))
