


# Used By Future Package To enable multithreading
plan(multiprocess)


# Holder For The Leastest Tweets
# tweets <-
#   reactiveValues(World = getLatestWorldTweets(), Arab = NULL)
# countiresNames <-
#   reactiveValues(Arab = arabCountries$countryName, Foriegn = NULL)
# 
# observeEvent(input$arabCountries, {
#   #req(input$arabCountries)
#  # drawArabCountriesPieChart()
# })

startListeningToWorldTweets <-
  function(queryString = "",
           listenFor = 3600,
           gzipEnabled = F,
           worldCoords = c(-180, -90, 180, 90),
           includeRts = T,
           logging = T) {
    fileName = ""
    countiresAnalytics %<-% {
      repeat {
        getWorldTweets <- future({
          if (logging)
            fileName = paste0("LoggedData/WorldTweets/",
                              format(Sys.time(), "%Y-%m-%d_%H-%M-%S_%p"))
          
          stream_tweets(
            q = queryString,
            worldCoords,
            timeout = listenFor,
            gzip = gzipEnabled,
            file_name = fileName,
            include_rts = includeRts
          )
        })
        
        updateWorldTweets <- future({
          worldTweets <- value(getWorldTweets)
          if (length(worldTweets$text) <= 1) {
            print("Couldn't Stream WorldTweets..")
            next
          }
          
          tweets$World <- worldTweets <-
            worldTweets[complete.cases(worldTweets$country_code),]
          tweets$Arab <- getArabTweets(worldTweets)
          
          
          print(paste0("World Tweets: " , length(isolate(tweets$World)$text)))
          
          print(paste0("Arab Tweets: " ,
                       length(isolate(tweets$Arab)$text)))
        })
        
        printLine()
      } #end Repeat
    }
  }


drawArabCountriesPieChart <- function() {
  worldTweets <- isolate(tweets$World)
  # Null if there is no files in the directory
  if (is.null(worldTweets)) {
    print("Do not have any World Tweets ")
    return()
  }
  arabTweets <- isolate(tweets$Arab)
  if (is.null(arabTweets)) {
    arabTweets <- getArabTweets(worldTweets)
  }
  
  noOfWorldTweets <- nrow(worldTweets)
  noOfCountryTweets <- c()
  for (countryCode in arabCountries$countryCode) {
    percentageOfCountryTweets <-
      c(noOfCountryTweets,
        (nrow(worldTweets[which(worldTweets$country_code == countryCode), ]) / noOfWorldTweets) * 100)
  }
  
  arabCountriesStatistics <-
    data.frame("countryName" = arabCountries$countryName, percentageOfCountryTweets)
  noOfOthersTweets <- noOfWorldTweets - nrow(arabTweets)
  arabCountriesStatistics[nrow(arabCountriesStatistics) + 1,] = c("Others", noOfOthersTweets / noOfWorldTweets)
  
  output$arabCountriesPieChart <- renderPlotly({
    p <-
      plot_ly(
        arabCountriesStatistics,
        labels = ~ countryName,
        values = ~ percentageOfCountryTweets,
        type = 'pie',
        textposition = 'inside',
        textinfo = 'label+percent',
        insidetextfont = list(color = '#FFFFFF')
      ) %>%
      layout(
        title = 'Arab Countries Tweets Last Hour',
        xaxis = list(
          showgrid = FALSE,
          zeroline = FALSE,
          showticklabels = FALSE
        ),
        yaxis = list(
          showgrid = FALSE,
          zeroline = FALSE,
          showticklabels = FALSE
        )
      )
    
  })
}


#startListeningToWorldTweets()
