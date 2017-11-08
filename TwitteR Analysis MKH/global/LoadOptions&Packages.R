
# Hold packages Versions at a particular date So it can be the same on Others Machines
packagesSnapShotDate = "2017-08-19"

options(
  repos = c(CRAN = paste0(
    'https://mran.microsoft.com/snapshot/', packagesSnapShotDate
  )),
  stringsAsFactors = F,
  shiny.reactlog =F,
  shiny.autoreload = F,
  shiny.trace = T,
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
  EnsurePackage("devtools")
  EnsurePackage("mkearney/rtweet",github = T) # Provide Abstraction of Twitter APIs
  EnsurePackage("future") # Enable MultiProcessing Mechanism
  EnsurePackage("shiny")  # Web Server and Basic UI Elements in R
  EnsurePackage("shinyjs") # shiny's Extension to enable easy ui manipulation
  EnsurePackage("shinycssloaders") # shiny's Extension to show loading animation
  EnsurePackage("shinythemes") # shiny
  EnsurePackage("V8") # Engine Provided by google to enable processing javascript in Server side
  EnsurePackage("jsonlite") # Convert to/from json
  EnsurePackage("dplyr") # deep layer provides advanced filters and data manipulation
  EnsurePackage("carlganz/shinyCleave", github= T) #UI Notification Library
  EnsurePackage("leaflet") # Map based on widely known js library 
  EnsurePackage("leaflet.extras") # Leaflet's extension provides more control over elements
  EnsurePackage("plotly") # provide Charts 
  EnsurePackage("tm")  # for text mining
  EnsurePackage("wordcloud") # word-cloud generator 
  EnsurePackage("RColorBrewer") # color palettes
}
LoadLibraries()


# Create Global Enviroment Variable Holding Tokens
# inputs (appname , keys readed from token.txt file)
create_token(
  app = "Twitter Analysis MKH",
  consumer_key = readLines("tokens.txt")[1],
  consumer_secret = readLines("tokens.txt")[2],
  cache = TRUE
)