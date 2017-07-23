
# Hold packages Versions at a particular date So it can be the same on Others Machines
snapShotDate = "2017-07-20"

options(
  repos = c(CRAN = paste0(
    'https://mran.microsoft.com/snapshot/', snapShotDate
  )),
  stringsAsFactors = FALSE,
  shiny.reactlog =T,
  shiny.autoreload = F,
  shiny.trace = F,
  shiny.error = browser,
  shiny.minified = F
)

# Establish Load Libraries processing
EnsurePackage <- function(x, github = FALSE) {
  x <- as.character(x)
  if (github) {
    y <- x
    x <- gsub(".*/", "", x)
  }
  if (!require(x, character.only = TRUE)) {
    #if (!x %in% installed.packages()) {
    
    if (!github)
      install.packages(x)
    else
      devtools::install_github(y)
    
    library (x, character.only = TRUE)
  }
}

LoadLibraries <- function() {
  EnsurePackage("devtools")
  EnsurePackage("rtweet")
  EnsurePackage("future")
  EnsurePackage("shiny")
  EnsurePackage("shinyjs")
  EnsurePackage("V8")
  EnsurePackage("jsonlite")
  EnsurePackage("dplyr")
  EnsurePackage("carlganz/shinyCleave", github = T) #UI Notification Library
  EnsurePackage("rstudio/leaflet", github = T)
  EnsurePackage("bhaskarvk/leaflet.extras", github = T)
  #EnsurePackage("ramnathv/rCharts",github = T)
  #EnsurePackage("sqldf")
  #EnsurePackage("stringr")
  #EnsurePackage("rgdal")
  #EnsurePackage("ggmap")
  #EnsurePackage("shinythemes")
  
}
LoadLibraries()

# Used By Future Package To enable multithreading
plan(transparent)

# Create Enviroment Variable Holding our token
create_token(
  app = "Twitter Analysis MKH",
  consumer_key = readLines("tokens.txt")[1],
  consumer_secret = readLines("tokens.txt")[2],
  cache = TRUE
)