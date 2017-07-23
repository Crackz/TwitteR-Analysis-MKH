library("future")
library("rtweet")
#plan(multiprocess)
arabCountriesCodes <-
  read.csv2(
    "ShapeCountries/Arab_Countries.csv",
    header = T,
    stringsAsFactors = F,
    sep = ",",
    quote = ""
  )

plan(mutlicore)
printLine <- function() {
  cat("------------------------------------------------------------------")
}

startListeningWorldTweets <-
  function(queryString = "",
           listenFor = 30,
           gzipEnabled = T,
           worldCoords = c(-180, -90, 180, 90),
           includeRts = F,
           logging = T) {
    fileName = ""
    repeat {
      listenWorldTweets <- future({
        if (logging)
          fileName = paste0("LoggedData/WorldTweets/",
                            format(Sys.time(), "%Y-%m-%d_%H-%M-%S_%p"))
        
        worldTweets <- stream_tweets(
          q = queryString,
          worldCoords,
          timeout = listenFor,
          gzip = gzipEnabled,
          file_name = fileName,
          include_rts = includeRts
        )
        if (!is.data.frame(worldTweets) ||
            is.na(worldTweets$text[1]) ||
            is.na(worldTweets)) {
          cat("Couldn't Stream WorldTweets..")
          next
        }
        # assign to left side variable
        worldTweets
      })
      
      updateCountriesAnalytics <- future({
        while (!resolved(listenWorldTweets)) {
          print("Waiting for listenWorldTweets to finish ...")
        }
        worldTweets <- value(listenWorldTweets)
        print(paste0("World Tweets: " , length(worldTweets$text)))
        arabCountriesTweets <-
          subset(worldTweets , country_code %in% arabCountriesCodes)
        #worldTweets[worldTweets$country_code %in% arabCountriesNames,]
        print(paste0(
          "Arab Countries Tweets: " ,
          length(arabCountriesTweets$text)
        ))
      })
      
      printLine()
    }
  }

startListeningWorldTweets()
