# Establish Global Listener
observe({
    toggleState("btnAnalyze", input$searchQuery != "" && input$trendLocations != "" && input$selectedLang != "" && input$noTweets != "")
    # updateTextInput(session , "noTweets" , value = input$noTweetsSlider)     
        
}) # End Global Listenerþ

# Configurations for Number of Tweets Input
cleave(session, "#noTweets", list(
    numeral = TRUE,
    numeralPositiveOnly = TRUE,
    delimiter = '',
    numeralDecimalScale = 0
))


startTime <- Sys.time()
observeEvent(input$noTweets, {
    if (!is.na(as.numeric(input$noTweets)))
       noTweets <- as.numeric(input$noTweets)
    else {
        showNotification("Please: Enter a valid number", type = "error")
        return();
    }
    if (noTweets == 0) {
        updateTextInput(session, "noTweets", value = 100)
        showNotification("Please , Enter a valid number", type = "error")
    }
   interval <- 300
   sleepTime <- startTime + interval - Sys.time()
   if (noTweets < 100 && sleepTime < 0) {
        showNotification("Note: That minimum tweets is 100 tweets", type = "warning")
        startTime <- Sys.time() 
   } 
    updateSliderInput(session, "noTweetsSlider", value = noTweets,
                                min = ceiling(noTweets * 0.5), max = ceiling(noTweets * 1.5))

})

observeEvent(input$noTweetsSlider, {
    if (input$noTweetsSlider < 100)
        showNotification("Note: That minimum tweets is 100 tweets", type = "warning")
})

#change automatically based on selected country
countryLanguages <- reactive({
    # instead of if(trendLocation == null)
    req(input$trendLocations)
    # should add empty char to be able to use list in updateSelectizeInput & ignore exception
    c(getCountryLanguages(input$trendLocations), "")
})

observeEvent(input$trendLocations, {
    if (input$trendLocations != "") {
        updateSelectizeInput(session, 'searchQuery', choices = getCountryTrendsNames(input$trendLocations) , server = TRUE)
        updateSelectizeInput (session, 'selectedLang',
                              choices = list("Most Used" = countryLanguages(), "Others" = setdiff (getCountriesLanguages(), countryLanguages() )),
                              selected= countryLanguages()[1] )
    }
})


observeEvent(input$btnAnalyze, {

    withBusyIndicatorServer("btnAnalyze", {
        # Call Search Tweets API with form values
        tweetsJson <- getTweets( input$searchQuery , as.numeric( input$noTweets ) , input$selectedLang )

        # Check is it a valid Json Or it's text containing Error 
        if (validate(tweetsJson)) {
            session$sendCustomMessage("CreateTweets", tweetsJson)
        }
        else {
            stop(tweetsJson) #Print The Returned Text 
        }
    })
}) #End btnAnalyze event

#Reset Form Values when Button Reset clicked !
observeEvent(input$resetSearchPanel, {
    reset("searchPanel")
    runjs("clearTweets();")
})

