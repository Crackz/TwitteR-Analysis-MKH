# NOTE: Can't use Reactivity HERE!
# Designed To contain Global Funs that can be accessed by ui and server 
# global.r vs server.r => server.r will be Established for every client Session

source(file.path("global", "LoadOptions&Packages.R"), local = TRUE)

##########################################################    Search Tweets  ##############################################################

getTweets <- function (searchQuery, noTweets, selectedLang) {
  if (getRateLimitFor("search/tweets")$remaining > 0) {
    # Concatenate chars vector in search box into one string with space between every word
    searchQuery <- paste0(searchQuery, collapse = " ")
    selectedLang <-
      subset(availableCountriesLanaguagesCodes,
             lang_fullname == selectedLang)[["lang_abbr"]]
  
    twtdf <-
      search_tweets (
        searchQuery,
        n = noTweets,
        lang = selectedLang,
        include_rts = FALSE,
        full_text = TRUE
      )
    # Strange behaviour in parameter (include_entitites=T) returning twt as a list
    
    #save_as_csv(twtdf, "LoggedData/Saved_Tweets.csv")
    
    # Check if got results or not
    if (!is.na(twtdf$text[1])) {
      twtJson <- toJSON(twtdf, pretty = TRUE)
      return(twtJson)
      
    } else
      return ("Can't find What you are looking for ...")
    
  } else {
    return (exceedsTwitterLimits("search/tweets"))
  }
}

############################################################### Trends #########################################################
availableTrendLocations <- trends_available()
availableCountriesLanaguagesCodes <-
  read.csv("ShapeCountries/language-codes.csv", stringsAsFactors = FALSE)
availableCountriesLanaguages <-
  read.csv("ShapeCountries/CountriesLanguages.csv", stringsAsFactors = FALSE)
avialableCountries<- read.csv("ShapeCountries/countriesNames.csv", stringsAsFactors = F)
availableTrendLocations <-
  left_join(availableTrendLocations, availableCountriesLanaguages, by = "countryCode")

arabCountries <-
  read.csv2(
    "ShapeCountries/ArabCountries.csv",
    header = T,
    stringsAsFactors = F,
    sep = ","
  )
#Convert countryLanguages to List Of Vectors
availableTrendLocations$countryLanguages <-
  lapply(availableTrendLocations$countryLanguages, function(countryLanguagesCell) {
    #Check if the cell contains more than one lang
    if (grepl("\\W", countryLanguagesCell)) {
      countryLanguagesCell <-
        regmatches(countryLanguagesCell,
                   gregexpr("[A-za-z]+", countryLanguagesCell))[[1]]
      return(countryLanguagesCell)
      
    } else
      return(countryLanguagesCell)
  })

getCountriesNames <- function() {
  # remove any empty cell first then and any duplication then sort
  return (sort(unique(availableTrendLocations$country[availableTrendLocations$country != ""])))
}

getArabCountriesNames <- function() {
  return(arabCountries$countryName)
}

getCountryTrends <- function (countryName) {
  if (countryName == 'Selected Region') {
    # New Way to get Trends
    return()
  }
  if (getRateLimitFor("trends/place")$remaining > 0) {
    #Get woeid(Where On Earth) of selected country
    currentCountryWoeid <-
      subset(availableTrendLocations, name == countryName)[["woeid"]]
    
    return (get_trends(currentCountryWoeid))
  } else
    return (exceedsTwitterLimits("trends/place"))
}

getCountryTrendsNames <- function(countryName) {
  return (getCountryTrends(countryName)$trend)
}

getCountriesLanguages <- function () {
  return(sort(unique(
    unlist(availableTrendLocations$countryLanguages)
  )))
}

getCountryLanguages <- function (countryName) {
  # if (countryName == "Worldwide")
  #   return(c("English"))
  if (countryName == "Worldwide" ||
      countryName == "" ||
      countryName == "Selected Region")
    return(vector())
  
  countrylanguages <-
    availableTrendLocations[which(availableTrendLocations$country == countryName),]$countryLanguages[1]
  return(unlist(countrylanguages))
}

getCountryBoundary<- function(countryName){
  return ( as.list(lookup_coords(countryName)@box) )
}

getRateLimitFor <- function (queryRateLimit) {
  return (rate_limit(queryRateLimit, token = NULL))
}

getForiegnCountriesNames<- function(){
  return(NULL)
}

getLatestWorldTweets<- function() {
  worldTweetsPath = file.path(getwd(),"LoggedData/WorldTweets")
  worldTweetsFiles = list.files(worldTweetsPath)
  if(length(worldTweetsFiles) == 0) return(NULL)
  tailNumber = 1
  repeat{
    lastFileName <- tail(worldTweetsFiles,n = tailNumber)[1]
    if(file.info(file.path(worldTweetsPath,lastFileName))$size > 1000 || tailNumber == length(worldTweetsFiles)){
      break
    }
    tailNumber <- tailNumber + 1 
  }
  print(paste0("Loading ",lastFileName))
  worldTweets<- parse_stream(file.path(worldTweetsPath,lastFileName))
  worldTweets <-
    worldTweets[complete.cases(worldTweets$country_code),]
  return(worldTweets)
}

getArabTweets<-function(worldTweets){
  return( worldTweets[worldTweets$country_code %in% arabCountries$countryCode,] )  
}

exceedsTwitterLimits <- function (queryRateLimit) {
  textLimitReach <-
    paste0(
      queryRateLimit,
      " Exceeds Limit..Reset In : ",
      round(getRateLimitFor(queryRateLimit)$reset, 2) ,
      " Minutes"
    )
  print(textLimitReach)
  return (textLimitReach)
}

printLine <- function() {
  cat("------------------------------------------------------------------")
}