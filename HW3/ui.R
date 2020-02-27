#' @import shiny
ui <- fluidPage(
  tabsetPanel(
    tabPanel("Map", 
             
             titlePanel("Overview the Distribution of Corona Virus in China"),
             
             sidebarLayout(
               sidebarPanel(
                 helpText("Create demographic maps with 
                          data from JHU on 2019-nCoV Outbreak."),
                 
                 radioButtons("case", "Select A Case Category:",
                              c("Confirmed" = "c",
                                "Recovered" = "r",
                                "Death" = "d")
                              ),
                 
                 dateInput("date", "Select a date:", value = "2020-02-25", 
                           format = "mm/dd/yy"),
               ),
               
               mainPanel(plotOutput("plot1"))
               
              )
    ),
    
    tabPanel("Line Graph", 
             
             titlePanel("Select Dates to Have a Comparison among Different Cases..."),
             
             sidebarLayout(
               sidebarPanel(
                 helpText("Create a line graph with selected time interval."),
                 
                 dateRangeInput("dates", 
                                "Select the range of date:",
                                start = "2020-01-22", 
                                end = "2020-02-25")
               ),
               mainPanel(plotOutput("plot2"))
             )
     ),
    
    tabPanel("Counts", 
             
             titlePanel("See How it Grew over time in Different Provinces"),
             
             sidebarPanel(helpText("Please wait for a couple minutes, 
                                   the gif is being generated.")),
             
             flowLayout(plotOutput("plot3"))
    )
   )
)