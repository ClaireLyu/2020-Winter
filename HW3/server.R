#' @import shiny
library(gganimate)
library(transformr)
library("viridis")
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
  
  dataInput3 <- reactive({
    
    ncov_tbl %>%
      filter(`Country/Region` %in% 
               c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
      getSymbols(src = "yahoo", 
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
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
      scale_fill_viridis(option = "B", trans = "log10", discrete = FALSE, 
                         direction = -1) +
      #scale_fill_gradientn(colors = wes_palette("Zissou1", 100, type = "continuous"),
      #                     trans = "log10") + 
      theme_bw() +
      labs(title = str_c(dataInput1(), " cases"), subtitle = dataInput2())
  })
  
  output$plot2 <- renderPlot({
    
    dataInput3() %>%
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
  
  output$plot3 <- renderPlot({
    
    p <- ncov_tbl %>%
      filter(`Country/Region` %in% c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
      group_by(`Province/State`) %>%
      ggplot() +
      geom_col(mapping = aes(x = `Province/State`, y = `Count`, fill = `Case`)) + 
      scale_y_log10() +
      theme(axis.text.x = element_text(angle = 90))
    
    anim <- p + 
      transition_time(Date) + 
      labs(title = "Date: {frame_time}")
    animate(anim, renderer = gifski_renderer())
    anim_save("confirmed_anim.gif")
    print("confirmed_anim.gif")
    
  })
}