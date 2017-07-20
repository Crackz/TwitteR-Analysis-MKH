#look_coord Start using s4 return 3 var (place, box , )
# $V1 added to convert directly to vectors 
arabCountriesNames<- read.csv2("ShapeCountries/Arab_Countries.csv",header=F)$V1

library("future")
library("listenv")
library("rtweet")
plan(multiprocess)
timer= 30

countryFuture <- listenv()
startWatchingArabicCountries <- function(countriesNames) {
  for (countryName in countriesNames)
  {
    print(countryName)
    countryFuture[[countryName]] <- future({
      countryBoundary <- getCountryBoundary(countryName)
      str(countryBoundary)
      print(length(countryBoundary))
      if (is.character(countryBoundary))
        stop(countryBoundary) # Print Error Message ..
      countryTweets <-
        stream_tweets(
         as.vector(countryBoundary),
          timeout = timer,
          #file_name = paste0("LoggedData/",countryName, "_Tweets_",format(Sys.time(), "%F_%H-%S"),".json")
          file_name = paste0("LoggedData/",countryName,".json")
        )
      
      if (shiny::isTruthy(countryTweets$text[1]) || length(countryTweets$text) > 1) {
        countryTweets
      
      } else {
         print(paste0("Can't Stream : ", countryName))
         next
      }
        
    })
  }
}

getCountryBoundary<- function(countryName){
  countryBoundary<- lookup_coords(countryName)
  if(is.null(countryBoundary)){
    return(paste0("Couldn't find country: ", countryName))
  }
  return(countryBoundary)
}


startWatchingArabicCountries(arabCountriesNames)

