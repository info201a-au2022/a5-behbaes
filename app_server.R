#this is app_server.R
library(dplyr)
#library(shiny)
library(plotly)
library(ggplot2)

climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

server <- function(input, output) {
  output$income <- renderText({
    #average CO2 output of high income countries since 2000
    co2_high_income <- climate_data %>% 
      filter(year >= 2000 & country == "High-income countries") %>% 
      summarize(avg_output = mean(co2)) %>% 
      pull(avg_output)
    rounded_value <- round(co2_high_income, digits=2)
    
    explanation <- paste0("The average CO2 output of high income countries since 2000 has been ", 
                          rounded_value, " million tons per year.")
    return(explanation)
  })
  
  output$country_highest_co2 <- renderText({
    #which country has highest CO2 emissions per capita in most recent year
    highest_per_capita <- climate_data %>% 
      filter(year == 2021) %>% 
      group_by(country) %>% 
      summarize(co2_for_country = co2_per_capita) %>% 
      filter(co2_for_country == max(co2_for_country, na.rm = TRUE)) %>% 
      pull(country)
    
    explanation2 <- paste0("The country with the highest CO2 emissions per capita in 2021 was ",
                           highest_per_capita, ".")
    return(explanation2)
  })
  
  output$num_countries_improved <- renderText({
    #num countries that have seen lower ghg emissions from 2010 to 2019 
    num_countries_lower_ghg <- climate_data %>% 
      filter(year == 2010 | year == 2019) %>% 
      group_by(country) %>% 
      summarize(ghg_change = diff(ghg_per_capita)) %>% 
      filter(ghg_change < 0) %>% 
      nrow()
    
    explanation3 <- paste0("From 2010 to 2019, ",
                           num_countries_lower_ghg,
                           " countries have seen lower greenhouse gas emissions per capita.")
    return(explanation3)
  })
  
  output$interactive_plot <- renderPlotly({
    plot_data <- climate_data %>% 
      filter(year > input$year_range[1], year < input$year_range[2]) %>% 
      filter(country == input$country)
    
    interactive_plot <- ggplot(data = plot_data, 
                        mapping = aes_string(x = plot_data$year, y = input$y_var)) + 
      geom_point() +
      labs(
        title = paste0(input$country, "'s ", input$y_var, " from ", input$year_range[1], " to ", input$year_range[2]),
        x = "Year",
        y = input$y_var
      ) +
      scale_y_continuous(labels = scales::comma)
    ggplotly(interactive_plot)
  })
}
