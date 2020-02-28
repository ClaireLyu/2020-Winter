#' @import shiny
ui <- fluidPage(
  
  tabsetPanel(
    
    tabPanel("Map", 
             titlePanel("Overview the Distribution of Corona Virus in China"),
             sidebarLayout(
               sidebarPanel(
                 helpText("Create demographic maps with 
                          data from JHU on 2019-nCoV Outbreak.",
                          "Note: it may take a minute to generate the image...
                          SORRY"),
                 radioButtons("case", "Select A Case Category:",
                              c("Confirmed" = "c",
                                "Recovered" = "r",
                                "Death" = "d")
                              ),
                 dateInput("date", "Select a date:", 
                           value = as.character(Sys.Date() - 2), 
                           format = "mm/dd/yy"),
               ),
               mainPanel(plotOutput("plot1"))
              )
    ),
    
    tabPanel("Counts", 
             titlePanel("See How it Grew over time in Different Provinces"),
             sidebarPanel(helpText("Please count down for one minute, 
                                   the GIF is being generated.")),
             flowLayout(plotOutput("plot2"))
    ),
    
    tabPanel("Line Graph", 
             titlePanel("Select Dates to Have a Comparison among 
                        Different Cases..."),
             sidebarLayout(
               sidebarPanel(
                 helpText("Create a line graph with selected time interval.",
                          "Note: it may take a minute to generate the image...
                          SORRY"),
                 dateRangeInput("dates", 
                                "Select the range of date:",
                                start = "2020-01-22", 
                                end = as.character(Sys.Date() - 2))
               ),
               mainPanel(plotOutput("plot3"))
             )
     ),
    
    tabPanel("Stock", 
             titlePanel("See How it affects the stock over time"),
             sidebarPanel(helpText("Please count down for one minute, 
                                   the GIF is being generated.")),
             flowLayout(plotOutput("plot4"))
    )
    
   )
  
)