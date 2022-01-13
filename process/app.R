# Interactive lake evaporation model 

# Libraries and scripts----
pacman::p_load(here, shiny, tidyverse, ggthemes)

# Evaporation line model
source(here("process/evaporation-model.R"))

# Data----

# This study
waters.rawdata <- read_csv(here("data/2016-2021_waters.csv"))
waters <- waters.rawdata |>
  # Simplify WaterType categories
  mutate(WaterType = str_replace_all(WaterType, 
                                     c("River Delta" = "River",
                                       "Deep Ground" = "Ground",
                                       "Shallow Ground" = "Ground",
                                       "Spring" = "Ground",
                                       "Evaporated Surface" = "Surface")))

# Data from Levin et al 2009
waters.Levin.rawdata <- read_excel(here("data/Levin_et_al_2009_raw_data.xls"))
waters.Levin <- waters.Levin.rawdata |>
  # Make WaterType categories consistent with this study
  mutate(WaterType = str_replace_all(Type, 
                                     c("spring" = "Ground",
                                       "bore hole" = "Ground",
                                       "river" = "River",
                                       "water hole" = "Ground",
                                       "tap" = "Ground",
                                       "stream" = "Surface",
                                       "well" = "Ground",
                                       "rain" = "Precipitation"))) |>
  # Filter arid latitudes 
  filter(between(Lat, 2, 5.1))



# Define UI----
ui <- fluidPage(
  
  titlePanel("Lake Turkana Isotope Hydrology"),
  h3("New measurements, evaporation model"),
  h4("January 2022"),
  
  fluidRow(
    column(3,
           h4("Scenario 1"),
           numericInput(inputId = "TC1",
                        label = "Temperature (C)",
                        value = 30,
                        min = 20,
                        max = 40,
                        step = 0.5),
           numericInput(inputId = "rh1",
                        label = "Relative humidity (0-1)",
                        value = 0.25,
                        min = 0,
                        max = 1,
                        step = 0.025),
           numericInput(inputId = "k1",
                        label = "Equilibrium factor k (0-1)",
                        value = 0.1,
                        min = 0,
                        max = 1,
                        step = 0.025),
           ),
    column(3,
           h4("Scenario 2"),
           numericInput(inputId = "TC2",
                        label = "Temperature (C)",
                        value = 30,
                        min = 20,
                        max = 40,
                        step = 0.5),
           numericInput(inputId = "rh2",
                        label = "Relative humidity (0-1)",
                        value = 0.25,
                        min = 0,
                        max = 1,
                        step = 0.025),
           numericInput(inputId = "k2",
                        label = "Equilibrium factor k (0-1)",
                        value = 0.1,
                        min = 0,
                        max = 1,
                        step = 0.025),
    ),
    column(3,
           h4("Scenario 3"),
           numericInput(inputId = "TC3",
                        label = "Temperature (C)",
                        value = 30,
                        min = 20,
                        max = 40,
                        step = 0.5),
           numericInput(inputId = "rh3",
                        label = "Relative humidity (0-1)",
                        value = 0.25,
                        min = 0,
                        max = 1,
                        step = 0.025),
           numericInput(inputId = "k3",
                        label = "Equilibrium factor k (0-1)",
                        value = 0.1,
                        min = 0,
                        max = 1,
                        step = 0.025),
    ),
    column(3,
           h4("Scenario 4"),
           numericInput(inputId = "TC4",
                        label = "Temperature (C)",
                        value = 30,
                        min = 20,
                        max = 40,
                        step = 0.5),
           numericInput(inputId = "rh4",
                        label = "Relative humidity (0-1)",
                        value = 0.25,
                        min = 0,
                        max = 1,
                        step = 0.025),
           numericInput(inputId = "k4",
                        label = "Equilibrium factor k (0-1)",
                        value = 0.1,
                        min = 0,
                        max = 1,
                        step = 0.025),
    ),
  ),
  
  plotOutput('plot')
  
)

# Define server logic ----
server <- function(input, output) {
  
  # Constant input isotope compositions from summary values (see notebook)
  d18Oi <- -1
  dDi <- 5
  d18Op <- 0
  dDp <- 10
  
  scenario1 <- reactive({
    c(
      "TC" = input$TC1,
      "rh" = input$rh1,
      "k" = input$k1,
      "d18Oi" = d18Oi,
      "dDi" = dDi,
      "d18Op" = d18Op,
      "dDp" = dDp
    )
  })
  # something breaks right here 
  LEL1 <- model.LEL(scenario1)
  
  output$plot <- renderPlot(
    ggplot(data = LEL1, aes(x = d18O, y = dD))
  )
}

# Run the application ----
shinyApp(ui = ui, server = server)
  