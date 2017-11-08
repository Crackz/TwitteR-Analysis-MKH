observe({
    toggleState(
    "btnAnalyze",
    isTruthy(input$searchQuery) &&
      isTruthy(input$currentSelectedCountry) &&
      isTruthy(input$selectedLang) && isTruthy(input$noTweets)
  )
    toggle(
    id = "animation",
    anim = TRUE,
    animType = "slide",
    time = 0.3,
    condition = input$isMapOn
  )
})

# Configurations for Number of Tweets Input
cleave(
  session,
  "#noTweets",
  list(
    numeral = TRUE,
    numeralPositiveOnly = TRUE,
    delimiter = '',
    numeralDecimalScale = 0
  )
)


countryMap <-
  leaflet(options = leafletOptions(
    minZoom = 1,
    maxZoom = 10,
    dragging = T,
    doubleClickZoom = T,
    worldCopyJump = T
  )) %>%

  addProviderTiles(providers$Esri.WorldStreetMap, options = providerTileOptions()) %>%
  addDrawToolbar(
    targetGroup = 'selectedRegion',
    singleFeature = T,
    circleOptions = drawCircleOptions(),#showRadius = T),
    editOptions = editToolbarOptions(),
#metric = T, feet = F, nautic =F
    polylineOptions = F,
    polygonOptions = F,
    rectangleOptions = F,
    markerOptions = F
  ) %>%
  addFullscreenControl() %>%
  addEasyButton(
    easyButton(
      icon = "fa-times",
      id = "closeMap",
      position = "topright",
      title = "Close",
      onClick = JS(
        "function(btn, map){
          if (map.isFullscreen()) map.toggleFullscreen();
          $('#btnMap').click();
        }"
      )
    )
  ) %>%
  addEasyButton(
    easyButton(
      icon = "fa-check",
      id = "doneMap",
      position = "topright",
      title = "Finish",
      onClick = JS(
        "function(btn, map){
          if (map.isFullscreen()) map.toggleFullscreen();
          $('#btnMap').click().addClass('active');
          $('#btnMap i').addClass('fa-check-square-o').removeClass('fa-square-o');
          var $select = $('#currentSelectedCountry').selectize();
          var selectize = $select[0].selectize;
          selectize.addOption({ value: 'Selected Region', label: 'Selected Region' });
          selectize.addItem('Selected Region');
        }"
      )
    )
  )

output$countryMap <- renderLeaflet({
    countryMap
})

# Never suspend Map may cause some issuess in Rendering
outputOptions(output, "countryMap", suspendWhenHidden = FALSE)
# 
# observeEvent(c(
#   input$countryMap_draw_deleted_features,
#   input$countryMap_draw_deletestart
# ), {
#     disable("doneMap")
# })
# 
# observeEvent(c(input$countryMap_draw_new_feature), {
#     enable("doneMap")
# })

currentDrawnCircle<- reactive({
  shapes <- input$countryMap_draw_all_features
  if(length(shapes$features) == 0){
   return() 
  }
  list(
    # Convert from Ft to mi
    circleRadius = shapes$features[[1]]$properties$radius * 0.000189393939,
    circleCoords = shapes$features[[1]]$geometry$coordinates,
    circleUnit="mi"
  )
})

observeEvent(input$countryMap_draw_all_features, {
  shapes <- input$countryMap_draw_all_features
  if(length(shapes$features) != 0){
    enable("doneMap")
    regionTrend<- getSelectedRegionTrends(currentDrawnCircle()$circleCoords)
    print(regionTrend)
    
    updateSelectizeInput(
      session,
      'searchQuery',
      choices = regionTrend,
      server = TRUE
    )
  }else{
    disable("doneMap")
  }
})

observeEvent(input$noTweets, {
    if (!is.na(as.numeric(input$noTweets)))
        noTweets <- as.numeric(input$noTweets)
    else {
        showNotification("Please: Enter a valid number", type = "error")
        return()
    }
    if (noTweets == 0) {
        updateNumericInput(session, "noTweets", value = 100)
        showNotification("Please , Enter a valid number", type = "error")
    }
    if (noTweets < 100) {
        showNotification("Note: That minimum tweets is 100 tweets", type = "warning")
    }
    updateSliderInput(
    session,
    "noTweetsSlider",
    value = noTweets,
    min = ceiling(noTweets * 0.5),
    max = ceiling(noTweets * 1.5)
  )
})

#change automatically based on selected country
countryLanguages <- reactive({
    req(input$currentSelectedCountry)
    # added empty string to let lang render as list in updateSelectizeInput & ignore exception
    c(getCountryLanguages(input$currentSelectedCountry), "")
})
prev<- reactiveValues(language=NULL)
observeEvent(input$currentSelectedCountry, {
  #browser()
  if (isTruthy(input$currentSelectedCountry)) {
    # Note: countryLanguages returns at least c("")
    if (length(countryLanguages()) != 1) {
      updateSelectizeInput(
        session,
        'selectedLang',
        choices = list(
          "Most Spoken" = countryLanguages(),
          "Others" = setdiff(getCountriesLanguages(), countryLanguages())
        ),
        selected = countryLanguages()[1]
      )
      prev$language<- countryLanguages()[1]
    } else{
      if (input$currentSelectedCountry == "Selected Region")
        selectedLang =  prev$language
      else
        selectedLang = ""
      updateSelectizeInput(session,
                           'selectedLang',
                           choices = getCountriesLanguages(),
                           selected = selectedLang)
    }
    if (input$currentSelectedCountry != "Selected Region") {
      updateSelectizeInput(
        session,
        'searchQuery',
        choices = getCountryTrendsNames(input$currentSelectedCountry),
        server = TRUE
      )
      if (input$currentSelectedCountry != "Worldwide") {
        countryCoords <- getCountryCoords(input$currentSelectedCountry)
        countryBoundary <- as.list(countryCoords$box)
        countryPoint <- countryCoords$point
        
        leafletProxy("countryMap") %>%
          setView(lng = countryPoint[["lng"]],
                  lat = countryPoint[["lat"]],
                  zoom = 4) 
      }
      else {
        # mapBounds <- input$countryMap_bounds
        #print(mapBounds)
        #print(input$countryMap_center)
        #center <- c(mean(mapBounds$north, mapBounds$south), mean(mapBounds$east, mapBounds$west))
        #leafletProxy("countryMap") %>% setView(center[1], center[2], zoom = 1)
      }
    }
  }
})


observeEvent(input$btnAnalyze, {
  withBusyIndicatorServer("btnAnalyze", {
    geoCode=NULL
    if(input$currentSelectedCountry == "Selected Region"){
      shape<- currentDrawnCircle()
      geoCode = paste(shape$circleCoords[2],shape$circleCoords[1],paste0(shape$circleRadius,shape$circleUnit),sep=",")
    }
    # Pass form values search tweets API
    tweetsJson <-
      getTweets(input$searchQuery, input$noTweets, input$selectedLang, geoCode = geoCode)
    
    # Check is it a valid Json Or it's text containing Error
    if (validate(tweetsJson)) {
      session$sendCustomMessage("CreateTweets", tweetsJson)
    }
    else {
      stop(tweetsJson) # Print The Returned Text
    }
  })
}) #End btnAnalyze event

#Reset Form Values when Button Reset clicked !
observeEvent(input$resetSearchPanel, {
  #reset all inputs and text inputs to its defaults
  reset("searchPanel")
  runjs("clearTweets();")
  # reset map coords
  output$countryMap <- renderLeaflet({
    countryMap
  })
})
