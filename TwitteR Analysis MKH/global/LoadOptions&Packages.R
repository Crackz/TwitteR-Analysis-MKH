
# Hold packages Versions at a particular date So it can be the same on Others Machines
packagesSnapShotDate = "2017-07-23"

options(
  repos = c(CRAN = paste0(
    'https://mran.microsoft.com/snapshot/', packagesSnapShotDate
  )),
  stringsAsFactors = F,
  shiny.reactlog =F,
  shiny.autoreload = F,
  shiny.trace = F,
  shiny.error = browser,
  shiny.minified = F
)

# Establish Load Libraries processing
EnsurePackage <- function(x, github = FALSE, repo="") {
  x <- as.character(x)
  if (github) {
    y <- x
    x <- gsub(".*/", "", x)
  }
  if (!require(x, character.only = TRUE)) {
    #if (!x %in% installed.packages()) {
    
    if (!github)
      if(repo != "")
        install.packages(x,repos=repo, type="source")
      else
        install.packages(x)
    else
      devtools::install_github(y)
    
    library (x, character.only = TRUE)
  }
}

LoadLibraries <- function() {
  #EnsurePackage("devtools")
  EnsurePackage("rtweet")
  EnsurePackage("future")
  EnsurePackage("shiny")
  EnsurePackage("shinyjs")
  EnsurePackage("shinycssloaders")
  EnsurePackage("V8")
  EnsurePackage("jsonlite")
  EnsurePackage("dplyr")
  EnsurePackage("carlganz/shinyCleave",github= T) #UI Notification Library
  EnsurePackage("leaflet")
  EnsurePackage("leaflet.extras")
  EnsurePackage("plotly")
  EnsurePackage("futile.logger") # For Logging
  EnsurePackage("tm")  # for text mining
  EnsurePackage("tm.lexicon.GeneralInquirer",repo="http://datacube.wu.ac.at")
  EnsurePackage("SnowballC") # for text stemming
  EnsurePackage("wordcloud") # word-cloud generator 
  EnsurePackage("RColorBrewer") # color palettes
}
LoadLibraries()


# Create Enviroment Variable Holding our token
create_token(
  app = "Twitter Analysis MKH",
  consumer_key = readLines("tokens.txt")[1],
  consumer_secret = readLines("tokens.txt")[2],
  cache = TRUE
)