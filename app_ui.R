#this is app_ui.R
#library(shiny)
library(plotly)
climate_data <- read.csv("https://raw.githubusercontent.com/owid/co2-data/master/owid-co2-data.csv")

introduction_page <- tabPanel(
  "Introduction",
  h2("Introduction"),
  p("In this Shiny App, I used the wrangling & visualization skills I learned in class to interpret CO2 data. In particular, I wanted
  to focus on which countries had higher CO2 output / potential contribution to global warming. The first variable I 
    chose to analyze was the average CO2 output of high income countries since 2000 (measure of CO2: average yearly CO2 output in million tons). 
    The second variable I chose to analyze was which country contributed
    the most emissions per capita in 2021 (measure of CO2: production based, excluding land use change, in tonnes per person). The third variable I chose to analyze was the number of countries that reduced
    their greenhouse gas emissions from 2010 to 2019, to show the progress that has been made towards reducing carbon in the atmosphere (measure of CO2: greenhouse gas emissions including land-use change
    and forestry, measured in tonnes of carbon dioxide-equivalents per capita).
    The questions answered (and 3 values) are included below: "),
  h3("What is the average CO2 output of high income countries since 2000 (in million tons)?"),
  p(textOutput("income")), 
  h3("Which country had the highest per capita emissions (tons per person) in 2021?"), 
  p(textOutput("country_highest_co2")),
  h3("How many countries have seen lower Greenhouse Gas emissions from 2010 to 2019 (tonnes of carbon dioxide equivalents per capita)?"),
  p(textOutput("num_countries_improved"))
)

inputs <- sidebarPanel(
  sliderInput(
    inputId = "year_range",
    label = "Choose year range",
    min = min(climate_data$year), 
    max = max(climate_data$year),
    value = range(climate_data$year)
  ), 
  selectInput(
    inputId = "y_var",
    label = "Choose your dependent variable",
    choices = colnames(climate_data)[-c(1,2,3)],
    selected = "population"
  ),
  selectInput(
    inputId = "country",
    label = "Choose your country",
    choices = unique(climate_data$country),
    selected = "Afghanistan"
  )
)

interactive_page <- tabPanel(
  "Interactive Plot", 
  sidebarLayout(inputs, 
                mainPanel(plotlyOutput("interactive_plot"))),
  p("Purpose: This interactive plot allows users to choose a date range (time as the x-variable), y-variable, and country to see how
    a CO2 measure has changed throughout time. This is helpful for people who want to focus in on a specific time frame (such as recent periods) and region
    (country / continent), which can help form more specific analysis."),
  p("Patterns emerged: I noticed that some countries do not have as many data points as others, and rarely are there data points before 1800. 
    In the countries I tested out, some saw a steep linear increase in greenhouse gases. However, CO2 per GDP has decreased or returned to previous levels 
    in both rich and poor nations, indicating that countries are potentially using CO2 more efficiently than before. Finally, I noticed that levels of methane have increased
    globally since ~1990, which could explain the increase in greenhouse gases.")
)

ui <- navbarPage(
  # Application title
  titlePanel("INFO 201 Assignment 5"),
  introduction_page,
  interactive_page
  )
