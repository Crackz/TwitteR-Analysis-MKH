
# Hold packages Versions at a particular date So it can be the same on Others Machines
snapShotDate = "2017-07-23"

options(
  repos = c(CRAN = paste0(
    'https://mran.microsoft.com/snapshot/', snapShotDate
  )),
  stringsAsFactors = F,
  shiny.reactlog =F,
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
  EnsurePackage("shinyCleave") #UI Notification Library
  EnsurePackage("leaflet")
  EnsurePackage("leaflet.extras")
  EnsurePackage("plotly")
  EnsurePackage("futile.logger")
 
}
LoadLibraries()


# Create Enviroment Variable Holding our token
create_token(
  app = "Twitter Analysis MKH",
  consumer_key = readLines("tokens.txt")[1],
  consumer_secret = readLines("tokens.txt")[2],
  cache = TRUE
)