
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(leaflet)

shinyUI(fluidPage(
  
  theme = "style.css",
  tags$head(tags$style(HTML("
  .marker-custom {
  background-color: rgba(256, 0, 0, 1);
  border-radius: 20px;
  }

  .marker-custom div {
    background-color: rgba(110, 204, 57, 1);
    }
    "))),
  
    # Application title
  titlePanel("Toronto Cycling Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      helpText("This viz shows one month worth of cycling data from the City of Toronto's Bike App.")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      sliderInput("datapoints", "Number of points to plot: ", 1000, 330000, 5000, 
                  step = 1000 ),
      leafletOutput("cycleMap",
                    height = 500)
    )
  )
))
