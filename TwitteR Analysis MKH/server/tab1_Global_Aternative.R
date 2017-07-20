library("future")
library("rtweet")
#plan(multiprocess)
arabCountriesNames <-
  read.csv2("ShapeCountries/Arab_Countries.csv", header = F)$V1

plan(transparent)
printLine <- function() {
  cat("------------------------------------------------------------------")
}

startListeningWorldTweets <-
  function(listenFor = 30,
           gzipEnabled = T,
           worldCoords = c(-180, -90, 180, 90),
           logging = T) {
    fileName = ""
    repeat {
      if (logging)
        fileName = paste0("LoggedData/WorldTweets/",
                          format(Sys.time(), "%Y-%m-%d_%H-%M-%S_%p"))
      
      listenCountriesTweets <- future({
        worldTweets <- stream_tweets(
          worldCoords,
          timeout = listenFor,
          gzip = gzipEnabled,
          file_name = fileName
        )
        if (is.na(countriesTweets$text[1]) ||
            is.na(countriesTweets)) {
          cat("Couldn't Stream WorldTweets..")
          next
        }
        countArabCountriesTweets(worldTweets)
      })
      printLine()
    }
  }

countArabCountriesTweets <- function (worldTweets) {
  print(paste0("World Tweets: " , length(worldTweets)))
  arabCountriesTweets <- worldTweets[arabCountriesNames]
  print(paste0("Arab Countries Tweets " , length(arabCountriesTweets)))
  Sys.setenv(arabCountriesTweets)
}

startListeningWorldTweets()
