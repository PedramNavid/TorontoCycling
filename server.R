
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jsonlite)
library(dplyr)

get_trip_data <- function(max_offset = 1000, verbose = TRUE) {
  DATA_ID = "82a70e22-c7fe-4255-b283-d2d6e0a4dcd3"
  APIKEY = "2c92ac9fee4b1bee1e84530fc759d7b79d799b97775cd429b4c3cbdde0c9f5b5"
  raw_data <- data.frame()
  
  for(x in seq(0, max_offset, by = 250)) {
    URL = paste0("https://api.namara.io/v0/data_sets/", DATA_ID, "/data/en-0?api_key=", APIKEY,
               "&offset=", x)
    tmp <- fromJSON(URL)
    if (verbose & x %% 1000 == 0) cat(".")
    if (length(tmp) == 0) break
    raw_data <- rbind(raw_data, tmp)
  }
  
  location_cnt <- raw_data %>% 
    group_by(latitude, longitude) %>% 
    summarise(trips = n())
  
  return(location_cnt)
}


shinyServer(function(input, output) {

  
  output$cycleMap <- renderLeaflet({
    locations <- get_trip_data()
    
    map <- leaflet(locations) %>% 
      addTiles() %>% 
      addCircleMarkers(
        radius = 2,
        stroke = FALSE,
        fillOpacity = 0.5,
        clusterOptions = markerClusterOptions(maxClusterRadius = 20)) %>% 
      mapOptions(zoomToLimits = 'always')
    map
    
  })
  
})
