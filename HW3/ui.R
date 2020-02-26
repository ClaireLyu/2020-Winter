#' @import shiny
ui <- fluidPage(
  
  titlePanel("CoronaVirus Senser"),
  
  sidebarLayout(
    sidebarPanel(
      radioButtons("case", "Case Category:",
                   c("Confirmed" = "c",
                     "Recovered" = "r",
                     "Death" = "d")),
      
      dateInput("date", "Date:", value = "2020-02-25"), 
      format = "mm/dd/yy"),
    
    dateRangeInput("dates", 
                   "Date range",
                   start = "2020-01-22", 
                   end = "2020-02-25")
  ),
  
  mainPanel(
    fluidRow(splitLayout(cellWidths = c("50%", "50%"), 
                         plotOutput("plot1"), plotOutput("plot2")))
  )
)