# NOTE: Can't use Reactivity HERE!!
# Designed To contain Global Funs that can be accessed by ui and server ..
# global.r vs server.r => server.r will be Established for every client Session

# Establish Load Libraries processing
EnsurePackage <- function(x, github = FALSE) {
    x <- as.character(x)
    if (github) {
        y <- x
        x <- gsub(".*/", "", x)
    }
    if (!require(x, character.only = TRUE)) {
        if (!github)
            install.packages(pkgs = x, repos = "http://cran.r-project.org")
        else devtools::install_github(y)

        library (x, character.only = TRUE)
    }
}
options(stringsAsFactors = FALSE)

# Identifying packages required  
LoadLibraries <- function() {
    EnsurePackage("rtweet")
    EnsurePackage("shiny")
    EnsurePackage("shinyjs")
    EnsurePackage("V8")
    EnsurePackage("jsonlite")
    EnsurePackage("dplyr")
    EnsurePackage("carlganz/shinyCleave", github = T) #UI Notification Library
    #EnsurePackage("sqldf")
    #EnsurePackage("leaflet")
    #EnsurePackage("stringr")
    #EnsurePackage("rgdal")
    #EnsurePackage("ggmap")
}
LoadLibraries()
########################################################## Shared Between Tabs #########################################################
# Create Enviroment Variable Holding our token
create_token(app = "Twitter Analysis MKH", consumer_key = readLines("tokens.txt")[1], consumer_secret = readLines("tokens.txt")[2], cache = TRUE)

########################################################## Search Tweets ############################################################

getTweets <- function (searchQuery, noTweets, selectedLang) {

    if (getRateLimitFor("search/tweets")$remaining > 0) {

        # Concatenate chars vector in search box into one string with space between every word
        searchQuery <- paste0(searchQuery, collapse = " ")
        selectedLang <- subset(availableCountriesLanaguagesCodes, lang_fullname == selectedLang)[["lang_abbr"]]
        twtdf <- search_tweets (searchQuery, n = noTweets, lang = selectedLang,
                                include_rts = FALSE, full_text = TRUE, parse = TRUE )
        # Strange behaviour in parameter (include_entitites=T) returning twt as a list

        save_as_csv(twtdf, "LoggedData/Saved_Tweets.csv")

        # Check if got results or not 
        if (length(twtdf$text) > 1) {
            twtJson <- toJSON(twtdf, pretty = TRUE)
            write(twtJson, "LoggedData/Saved_Tweets.json")
            return(twtJson)

        } else return ("Didn't find What you are looking for ...")

    } else {
        return (exceedsTwitterLimits("search/tweets"))
    }
}

############################################################### Trends #########################################################
availableTrendLocations <- trends_available()
availableCountriesLanaguagesCodes <- read.csv("ShapeCountries/language-codes.csv", stringsAsFactors = FALSE)
availableCountriesLanaguages <- read.csv("ShapeCountries/CountriesLanguages.csv", stringsAsFactors = FALSE)
availableTrendLocations <- left_join(availableTrendLocations, availableCountriesLanaguages, by = "countryCode")

#Convert countryLanguages to List Of Vectors
availableTrendLocations$countryLanguages <- lapply(availableTrendLocations$countryLanguages, function(countryLanguagesCell) {
    if (grepl("\\W", countryLanguagesCell)) {
        countryLanguagesCell <- regmatches(countryLanguagesCell, gregexpr("[A-za-z]+", countryLanguagesCell))[[1]]
        return(countryLanguagesCell)

    } else return(countryLanguagesCell)
})

getCountryTrends <- function (currentCountryName) {
   
    if (getRateLimitFor("trends/place")$remaining > 0) {

        currentCountryWoeid <- subset(availableTrendLocations, name == currentCountryName)[["woeid"]]
        return (get_trends(currentCountryWoeid))

    } else {
        return (exceedsTwitterLimits("trends/place"))
    }
}

getCountryTrendsNames <- function (currentCountryName) {
    return (getCountryTrends(currentCountryName)$trend)
}

CountriesLanguages <- sort(unique(unlist(availableTrendLocations$countryLanguages)))
getCountriesLanguages <- function () {
    return(c("English", CountriesLanguages))
}

getCountryLanguages <- function (currentCountryName) {
    if (currentCountryName == "Worldwide") return(c("English"))
    if (currentCountryName == "") return(vector())
    languages <- availableTrendLocations[which(availableTrendLocations$country == currentCountryName),]$countryLanguages[1]
    return (unlist(languages))
}

getRateLimitFor<- function (queryRateLimit) {
    return (rate_limit(queryRateLimit, token = NULL))
}

exceedsTwitterLimits <- function (queryRateLimit) {
    textLimitReach <- paste0(queryRateLimit, " Exceeds Limit..Reset In : ", round(getRateLimitFor(queryRateLimit)$reset, 2) , " Minutes")
    print(textLimitReach)
    return (textLimitReach)
}




#countriesInfo <- geojsonio::geojson_read("ShapeCountries\\countries.geo.json", what = "sp")
#countriesInfo <- readOGR("ShapeCountries\\shapeCountries.shp", layer = "shapeCountries", encoding = "utf-8")


#Load Countries shape 
#countriesInfo <- geojsonio::geojson_read("ShapeCountries\\countries.geo.json", what = "sp")
#countriesInfo <- readOGR("ShapeCountries\\shapeCountries.shp", layer = "shapeCountries", encoding = "utf-8")

#Original countries Names inside column called admin so we have to rename it to sematic meaning
#names(countriesInfo)[names(countriesInfo) == 'admin'] <- 'countriesNames'




#getCountryTrends <- function(currentCountryLngLat) {
##print(paste0("Got This : ", currentCountryLngLat))
#if (getCurRateLimitInfo()$remaining[63] > 0) {
##Used To gain WoeId ( Where on Earth ID)
#countryDetails <- closestTrendLocations(currentCountryLngLat$lat, currentCountryLngLat$lng) #Note:Lat comes first

#if (!is.null(countryDetails))
#return(twitteR::getTrends(woeid = countryDetails$woeid))

#}
#else {
#textLimitReach <- paste0("GetTrends Reached Limit... Reset at: ", getCurRateLimitInfo()$reset[63])
#print(textLimitReach)
#return(textLimitReach)
#}
#}
#getCountryTrendsNames <- function(currentCountryID)
#{
#return(getCountryTrends(getCountryLngLat(currentCountryID))$name)
#}

#getCountryLngLat <- function(currentCountryID) {

#selectedReg <- countriesInfo[countriesInfo@data$countriesNames == currentCountryID,]
#countryLngLat <- as.list(selectedReg@polygons[[1]]@labpt) #labpt is a vector containing lng , lat for currentcountry
#names(countryLngLat) <- c("lng", "lat") #name them to be able to select by $
#return(countryLngLat)
#}


#getCountryPolygon <- function(currentCountryID) {
#return(countriesInfo[countriesInfo@data$countriesNames == currentCountryID,])
#}


#cleanTweets <- function(text) {
#clean_texts <- text %>%
#gsub("<.*>", "", .) %>% # remove emojis
#gsub("&amp;", "", .) %>% # remove &
#gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", .) %>% # remove retweet entities
#gsub("@\\w+", "", .) %>% # remove at people
#hashgrep %>%
#gsub("[[:punct:]]", "", .) %>% # remove punctuation
#gsub("[[:digit:]]", "", .) %>% # remove digits
#gsub("http\\w+", "", .) %>% # remove html links
#gsub("[ \t]{2,}", " ", .) %>% # remove unnecessary spaces
#gsub("^\\s+|\\s+$", "", .) %>% # remove unnecessary spaces
#tolower
#return(clean_texts)
#}
#hashgrep <- function(text) {
#hg <- function(text) {
#result <- ""
#while (text != result) {
#result <- text
#text <- gsub("#[[:alpha:]]+\\K([[:upper:]]+)", " \\1", text, perl = TRUE)
#}
#return(text)
#}
#unname(sapply(text, hg))
#}