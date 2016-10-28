
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jsonlite)
library(dplyr)
library(leaflet)


cycling_data <- "cycling-data/rds/location.rds"

if(!file.exists(cycling_data)) {
  raw_data <- readRDS("cycling-data/rds/toronto_cycling.rds")
  location_cnt <- raw_data %>% 
    group_by(longitude, latitude) %>% 
    summarise(n = n()) %>% 
    filter(longitude < -75) %>%  # Filter out weird NS data
    ungroup() %>% 
    sample_frac(1) # Shuffle everything so underplotting is more representative
saveRDS(location_cnt, cycling_data)
} else location_cnt <- readRDS(cycling_data)
  

shinyServer(function(input, output) {
  

  output$cycleMap <- renderLeaflet({
    
    map <- leaflet(location_cnt[1:input$datapoints,]) %>% 
      addTiles(urlTemplate = "http://{s}.tile.opencyclemap.org/cycle/{z}/{x}/{y}.png") %>% 
      addCircleMarkers(
        fillColor = "#F00",
        weight = n,
        clusterOptions = markerClusterOptions(maxClusterRadius = 10 ,
                                              chunkedLoading = TRUE,
                                              chunkInterval = 1000,
                                              iconCreateFunction =
JS("function(cluster) {
        return L.divIcon({ className: 'marker-custom', iconSize: L.point(10, 10) });
    }")),
        radius = 1,
        stroke = FALSE,
        fillOpacity = 1) %>% 
      mapOptions(zoomToLimits = 'first')
    map
    
    
  })
  
})
