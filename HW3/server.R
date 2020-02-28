#' @import shiny
library(gganimate)
library(transformr)
library(quantmod)
library(gifski)
library("viridis")
source("data.R")

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
      filter(ncov_tbl$Date %in% input$dates[1]:input$dates[2])
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
      theme_bw() +
      labs(title = str_c(dataInput1(), " cases"), subtitle = dataInput2())
  })
  
  output$plot3 <- renderPlot({
    dataInput3() %>%
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
  
  output$plot4 <- renderImage({
    q <- getSymbols("^HSI",
                    src = "yahoo", 
                    auto.assign = FALSE, 
                    from = min(ncov_tbl$Date),
                    to = max(ncov_tbl$Date)) %>% 
      as_tibble(rownames = "Date") %>%
      mutate(Date = date(Date)) %>%
      ggplot() + 
      geom_line(mapping = aes(x = Date, y = HSI.Adjusted)) +
      theme_bw()
    
    anim1 <- q + 
      transition_reveal(Date) 
    animate(anim1)
    anim_save(filename = "outfile1.gif")
    list(src = "outfile1.gif",
         contentType = 'image/gif')
  })

  output$plot2 <- renderImage({
    p <- ncov_tbl %>%
      filter(`Country/Region` %in% 
               c("Mainland China", "Macau", "Hong Kong", "Taiwan")) %>%
      group_by(`Province/State`) %>%
      ggplot() +
      geom_col(mapping = aes(x = `Province/State`, 
                             y = `Count`, fill = `Case`)) + 
      scale_y_log10() +
      theme(axis.text.x = element_text(angle = 90))
    
    anim2 <- p + 
      transition_time(Date) + 
      labs(title = "Date: {frame_time}")
    animate(anim2)
    anim_save(filename = "outfile2.gif")
    list(src = "outfile2.gif",
         contentType = 'image/gif')
  })
  
}