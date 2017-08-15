observe({
  toggleState(
    "btnAnalyze",
    isTruthy(input$searchQuery) &&
      isTruthy(input$currentSelectedCountry) &&
      isTruthy(input$selectedLang) && isTruthy(input$noTweets)
  )
  #print(str(input$countryMap_field_draw_features))
  #str(input$countryMap)
  toggle(
    id = "animation",
    anim = TRUE,
    animType = "slide",
    time = 0.3,
    condition = input$isMapOn
  )
  
  
  # print("--------------------input$countryMap_draw_new_feature-----------------------")
  # str(input$countryMap_draw_new_feature)
  # print("-------------------input$countryMap_draw_deleted_features----------------")
  # str(input$countryMap_draw_deleted_features)
  # print("--------------------input$countryMap_draw_feature-----------------------")
  # str(input$countryMap_group_selectedRegion)
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
    circleOptions = drawCircleOptions(showRadius = T),
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

# Never suspend Map causing some issuess in  Rendering
outputOptions(output, "countryMap", suspendWhenHidden = FALSE)

observeEvent(input$countryMap_field_draw_features, {
  print(
    "--------------------input$countryMap_field_draw_features----------------------"
  )
  
  str(input$countryMap_field_draw_features)
  
})

observeEvent(c(
  input$countryMap_draw_deleted_features,
  input$countryMap_draw_deletestart
),
{
  disable("doneMap")
})


observeEvent(c(input$countryMap_draw_new_feature), {
  enable("doneMap")
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
  # should add empty char to let lang render as list in updateSelectizeInput & ignore exception
  c(getCountryLanguages(input$currentSelectedCountry), "")
})

observeEvent(input$currentSelectedCountry, {
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
    } else
      updateSelectizeInput(session,
                           'selectedLang',
                           choices = getCountriesLanguages() ,
                           selected = "")
    
    if (input$currentSelectedCountry != "Selected Region") {
      updateSelectizeInput(
        session,
        'searchQuery',
        choices = getCountryTrendsNames(input$currentSelectedCountry),
        server = TRUE
      )
      if (input$currentSelectedCountry != "Worldwide") {
        countryBoundary <- getCountryBoundary(input$currentSelectedCountry)
        #countryCenter <- c("long" = mean(countryBoundary[1], countryBoundary[2]), "lat" = mean(countryBoundary[3], countryBoundary[4]))
        
        leafletProxy("countryMap") %>%
          setMaxBounds(countryBoundary[1],
                       countryBoundary[2],
                       countryBoundary[3],
                       countryBoundary[4]) %>%
          fitBounds(countryBoundary[1],
                    countryBoundary[2],
                    countryBoundary[3],
                    countryBoundary[4])
      }
    }
  }
  else {
    # mapBounds <- input$countryMap_bounds
    #print(mapBounds)
    #print(input$countryMap_center)
    #center <- c(mean(mapBounds$north, mapBounds$south), mean(mapBounds$east, mapBounds$west))
    #leafletProxy("countryMap") %>% setView(center[1], center[2], zoom = 1)
  }
  
})


observeEvent(input$btnAnalyze, {
  withBusyIndicatorServer("btnAnalyze", {
    # Pass form values search tweets API
    tweetsJson <-
      getTweets(input$searchQuery , input$noTweets , input$selectedLang)
    
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
  #reset all inputs and text inpupts to default null or default values..
  reset("searchPanel")
  runjs("clearTweets();")
  # reset map
  output$countryMap <- renderLeaflet({
    countryMap
  })
})
