# NOTE: Can't use Reactivity HERE!!
# Designed To contain Global Funs that can be accessed by ui and server ..
# global.r vs server.r => server.r will be Established for every client Session
options(shiny.reactlog = F, shiny.autoreload = F, shiny.trace =T, shiny.error = browser, shiny.minified = F, dstringsAsFactors = FALSE)

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

LoadLibraries <- function() {
    EnsurePackage("rtweet")
    EnsurePackage("shiny")
    #EnsurePackage("shinythemes")
    EnsurePackage("shinyjs")
    EnsurePackage("V8")
    EnsurePackage("jsonlite")
    EnsurePackage("dplyr")
    EnsurePackage("carlganz/shinyCleave", github = T) #UI Notification Library
    EnsurePackage("rstudio/leaflet", github = T)
    EnsurePackage("bhaskarvk/leaflet.extras", github = T)
    #EnsurePackage("sqldf")
    #EnsurePackage("stringr")
    #EnsurePackage("rgdal")
    #EnsurePackage("ggmap")
}
LoadLibraries()

#source("config.R") # ToDo Implementation
##########################################################    Shared Code    #############################################################
# Create Enviroment Variable Holding our token
create_token(app = "Twitter Analysis MKH", consumer_key = readLines("tokens.txt")[1], consumer_secret = readLines("tokens.txt")[2], cache = TRUE)

##########################################################    Search Tweets  ##############################################################

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
        if (!is.na(twtdf$text[1])) {
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
    #Check if the cell contains more than one lang
    if (grepl("\\W", countryLanguagesCell)) {
        countryLanguagesCell <- regmatches(countryLanguagesCell, gregexpr("[A-za-z]+", countryLanguagesCell))[[1]]
        return(countryLanguagesCell)

    } else return(countryLanguagesCell)
})

getCountriesNames <- function() {
    #remove any empty cell first then and any duplication then sort  
    return (sort(unique(availableTrendLocations$country[availableTrendLocations$country != ""]))) 
}

getCountryTrends <- function (currentCountryName) {
    if (currentCountryName == 'Selected Region') return()
    if (getRateLimitFor("trends/place")$remaining > 0) {
        #Get woeid(Where On Earth) of selected country
        currentCountryWoeid <- subset(availableTrendLocations, name == currentCountryName)[["woeid"]]

        return (get_trends(currentCountryWoeid))
    } else {
        return (exceedsTwitterLimits("trends/place"))
    }
}

getCountryTrendsNames <- function(currentCountryName) {
    return (getCountryTrends(currentCountryName)$trend)
}

CountriesLanguages <- sort(unique(unlist(availableTrendLocations$countryLanguages)))
getCountriesLanguages <- function () {
    return(CountriesLanguages)
}

getCountryLanguages <- function (currentCountryName) {
    if (currentCountryName == "Worldwide") return(c("English"))
    if (currentCountryName == "" || currentCountryName == "Selected Region") return(vector())

    countrylanguages <- availableTrendLocations[which(availableTrendLocations$country == currentCountryName),]$countryLanguages[1]
    return(unlist(countrylanguages))
}

getRateLimitFor<- function (queryRateLimit) {
    return (rate_limit(queryRateLimit, token = NULL))
}

exceedsTwitterLimits <- function (queryRateLimit) {
    textLimitReach <- paste0(queryRateLimit, " Exceeds Limit..Reset In : ", round(getRateLimitFor(queryRateLimit)$reset, 2) , " Minutes")
    print(textLimitReach)
    return (textLimitReach)
}







