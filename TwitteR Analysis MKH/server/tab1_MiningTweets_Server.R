#establish Global Listener

observe({
    toggleState("btnAnalyze", !is.null(input$searchQuery) && !is.null(input$trendLocations) && input$noTweets != "")
    #updateTextInput(session , "noTweets" , value = input$noTweetsSlider)     
        
}) #End Global Listenerþ



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

cleave(session, "#noTweets", list(
    numeral = TRUE,
    numeralPositiveOnly = TRUE,
    delimiter='',
    numeralDecimalScale = 0
))


observeEvent(input$trendLocations, {
    if (input$trendLocations != "") {
        updateSelectizeInput(session, 'searchQuery', choices = getCountryTrendsNames(input$trendLocations), server = TRUE)
    }
})

#btnAnalyze values When Button Search clicked !
observeEvent(input$btnAnalyze, {

   # print(paste0("Lang: ",input$selectedLang," | Search Query : ", input$searchQuery ) )     #" | Date : S/ " ,input$searchDateRange[1],"  D/ ",input$searchDateRange[2] ))

    withBusyIndicatorServer("btnAnalyze", {

        #print(paste0("Remaining Search Tweets Limit : ", rate_limit(query = "search/tweets", token = NULL)$remaining))

        #Begain Search Tweets API
        tweetsJson <- getTweets( input$searchQuery , as.numeric( input$noTweets ) , input$selectedLang )
        
        if (validate(tweetsJson)) {
            #Check is it a valid Json Or it's text containing Error 

            session$sendCustomMessage("CreateTweets", tweetsJson)
        }
        else {
            stop(tweetsJson) #Print The Returned Text 
        }
    })
}) #End btnAnalyze event

#Reset Values when Button Reset clicked !
observeEvent(input$resetSearchPanel, {
    reset("searchPanel")
    runjs("clearTweets();")

}) #end reset event

