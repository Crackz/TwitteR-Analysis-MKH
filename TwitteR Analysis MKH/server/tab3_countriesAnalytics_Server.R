# Used By Future Package To enable multithreading
plan(transparent)
tweets <- reactiveValues(World = NULL, Arab = NULL)

startListeningToWorldTweets <-
  function(listenFor = Inf,
           gzipEnabled = F,
           includeRts = T) {
    fileName = ""
      repeat {
        getWorldTweets <- future({
          fileName = paste0("LoggedData/WorldTweets/",format(Sys.time(), "%Y-%m-%d") ,".json")
          stream_tweets(
            # World coords
            c(-180, -90, 180, 90),
            # listening for that amount of time
            timeout = listenFor,
            # Not needed cuz we dont need to parse to any variable
            parse = FALSE,
            # File Name which tweets will be saved in
            file_name = fileName,
            # Compress type more reliable but less tweets
            gzip = gzipEnabled,
            # include Retweets ?
            include_rts = includeRts
          )
        })
      } #End Repeat
  }

drawArabCountriesPieChart <- function() {

   worldTweets <- getLatestWorldTweets()
   if(is.null(worldTweets)) {
     print("Couldn't load World Tweets")
     return()
   }
  arabTweets <- getArabTweets(worldTweets)
  
  noOfWorldTweets <- nrow(worldTweets)
  percentageOfCountryTweets <- c()
  for (countryCode in arabCountries$countryCode) {
    browser()
    percentageOfCountryTweets <-
      c(percentageOfCountryTweets,
        (nrow(worldTweets[which(worldTweets$country_code == countryCode),]) / noOfWorldTweets) * 100)
  }
  
  arabCountriesStatistics <-
    data.frame("countryName" = arabCountries$countryName, percentageOfCountryTweets)
  noOfOthersTweets <- noOfWorldTweets - nrow(arabTweets)
  arabCountriesStatistics[nrow(arabCountriesStatistics) + 1, ] <- c("Others", noOfOthersTweets / noOfWorldTweets)
  head(arabCountriesStatistics,40)
  
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
# 
# observeEvent(input$arabCountries,priority = -1,{
#    req(input$arabCountries)
#    drawArabCountriesPieChart()
#  })
# 
#  startListeningToWorldTweets()
