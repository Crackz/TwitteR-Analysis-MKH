# Holder For The Leastest Tweets
tweets <- reactiveValues(All=NULL, World = NULL, Arab = NULL)
countiresNames <-
  reactiveValues(Arab = arabCountries$countryName, Foriegn = NULL)

startListeningToWorldTweets <-
  function(queryString = "",
           listenFor = 20,
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
          
          worldTweets <- stream_tweets(
            q = queryString,
            worldCoords,
            timeout = listenFor,
            gzip = gzipEnabled,
            file_name = fileName,
            include_rts = includeRts
          )
          if (length(worldTweets$text) < 1) {
            print("Couldn't Stream WorldTweets..")
            next
          }
          tweets$World <-
            worldTweets[complete.cases(worldTweets$text), ]
          tweets$Arab <-
            subset(worldTweets ,
                   worldTweets$country_code %in% arabCountries$countryCode)
          
          print(paste0("World Tweets: " , length(isolate(
            tweets$World
          )$text)))
          
          print(paste0("Arab Countries Tweets: " ,
                       length(isolate(
                         tweets$Arab
                       )$text)))
          setForiegnCountriesNames()
        })
        
        printLine()
      }
    }
  }

setForiegnCountriesNames <- function ()
{
  countriesNames$All <- isolate(tweets$World)$country
  countiresNames$Foriegn <- setdiff(isolate(countriesNames$All), isolate(countriesNames$Arab))
  print(isolate(countiresNames$Foriegn))
}


startListeningToWorldTweets()
