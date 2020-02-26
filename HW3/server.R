#' @import shiny
server <- function(input, output) {
  
  dataInput1 <- reactive({
    case <- switch(input$case,
                   c = "confirmed",
                   r = "recovered",
                   d = "death")
  })
  
  dataInput2 <- reactive({
    date <- input$date
  })
  
  output$plot1 <- renderPlot({
    ncov_tbl %>%
      filter(`Country/Region` %in% 
               c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
      filter(Date == dataInput2(), Case == dataInput1()) %>%
      group_by(`Province/State`) %>%  
      top_n(1, Date) %>% # take the latest count on that date
      right_join(chn_prov, by = c("Province/State" = "NAME_ENG")) %>%
      ggplot() +
      geom_sf(mapping = aes(fill = Count, geometry = geometry)) +
      scale_fill_gradientn(colors = wes_palette("Zissou1", 100, type = "continuous"),
                           trans = "log10") + 
      theme_bw() +
      labs(title = str_c(dataInput1(), " cases"), subtitle = dataInput2())
  })
  
  output$plot2 <- renderPlot({
    
    ncov_tbl %>%
      filter(`Country/Region` %in% 
               c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
      group_by(Date, Case) %>%  
      summarise(total_count = sum(Count)) %>%
      ggplot() +
      geom_line(mapping = aes(x = Date, y = total_count, color = Case),
                size = 2) + 
      scale_color_manual(values = c("blue", "black", "green")) + 
      scale_y_log10() + 
      labs(y = "Count") + 
      theme_bw()
    
  })
}