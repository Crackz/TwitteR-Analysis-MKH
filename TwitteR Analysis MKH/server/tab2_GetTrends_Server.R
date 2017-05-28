#Notes:
# currentCountry is always an object containing id , lng, lat 
#


#Inital&Render Trends Map
output$trendsMap <- renderLeaflet({
  leaflet(countriesInfo,options = leafletOptions(minZoom = 3, maxZoom = 5,worldCopyJump = T,doubleClickZoom= F)) %>%
    addProviderTiles(providers$Esri.WorldStreetMap)%>%
    
    #addTiles(
      #urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png" #options = providerTileOptions(noWrap = TRUE)
      #urlTemplate= "//api.mapbox.com/v4/mapbox.emerald/page.html?access_token=pk.eyJ1IjoidmlwYTAwIiwiYSI6ImNqMGJka2p2YzAzZzgyd28ydjd5dGtxeHkifQ.YG-_WhA9LrhmaE_BtJrDGg"
   # ) %>%
    addPolygons(layerId=~countriesNames,group="Countries",color = "white", weight = 1, smoothFactor = 3,
                opacity = 1.0,fillOpacity = 0.4,dashArray = "1",label = ~countriesNames,
                highlightOptions = highlightOptions(color = "black", weight = 1,dashArray = "2",bringToFront = TRUE))
})#End trends map

proxy <- leafletProxy("trendsMap") #MapSelector use it to manipulate map in RunTime


observeEvent(input$trendsMap_shape_mouseover, {
  
  
})


#Country Selection from input
observeEvent(input$countrySelector,{
  if(input$countrySelector != ""){
    currentCountry <- getCountryLngLat(input$countrySelector) #Create Object with lng,lat only
    currentCountry$id <- input$countrySelector # add id to it
    focusOnCountry(currentCountry)
  }
    
}) 

#Country Selection on Click
observeEvent(input$trendsMap_shape_click, {  
  
  #create object for clicked polygon
  currentCountry <- input$trendsMap_shape_click

  #UnSelect CurrentCountry
  if(currentCountry$group == "selected"){
    proxy %>% clearGroup(group = "selected") %>% setView(currentCountry$lng,currentCountry$lat,zoom=3)
    updateSelectInput(session, "countrySelector", selected="")
    
  } #END Unselect Country
  
  #Select CurrentCountry
  if(!is.null(currentCountry$id)){
    if(is.null(input$countrySelector) || input$countrySelector != currentCountry$id)
    {
      updateSelectInput(session, "countrySelector", selected=currentCountry$id)
      focusOnCountry(currentCountry)
    }
  }
}) #END Country Selection on Click




observeEvent(input$getTrends,
{
  #Make Sure that he selected a country
  if(input$countrySelector!=""){
      
      trends<- getCountryTrends(getCountryLngLat(input$countrySelector))
      if(!is.character(trends)){
        show("trendsPanel")
        tags$script(HTML("$(\"#getTrends\").click(function() { $(\"#trendsPanel\").empty(); }"))
        
        
        # output$hist <- renderPlot({
        # })
        #str(trends)
        #print(dim(trends))
        #print(dim(trends$name))
     
        lapply(1:dim(trends)[1], function(i) {
          output[[paste0('trend', i)]] <- renderUI({
            strong(paste0(trends$name[i]))
          })
        })      
      }
      else showModal(modalDialog(title = trends , easyClose = TRUE))
  }
  else showModal(modalDialog(title = "Invalid Input Message","Please , Select A Country !!",easyClose = TRUE))

})



#Zoom and Highlight selected Country
focusOnCountry<- function(currentCountry)
{
  proxy %>% clearGroup(group = "selected") %>% 
  
  fitBounds(lng1 = max(currentCountry$lng),lat1 = max(currentCountry$lat)
            ,lng2 = min(currentCountry$lng),lat2 = min(currentCountry$lat)) %>%
    
  addPolygons(data = getCountryPolygon(currentCountry$id) ,fillColor = "red",weight = 1 ,color = "black", stroke = T , group = "selected")
   
}

observeEvent(input$closeTrendsPanel,{
  hide("trendsPanel")
  
})