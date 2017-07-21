shinyServer(function(input, output, session) {
  #------------------------------------- Twitter Anaylsis TAB 1 ----------------------------------#
  source(file.path("server", "tab1_MiningTweets_Server.R"), local = TRUE)
  
  #------------------------------------- User Profile TAB 2 --------------------------------------#
  source(file.path("server", "tab2_UserProfile_Server.R"), local = TRUE)
  
  #-------------------------------------# Trends Map TAB 2 ---------------------------------------#
  source(file.path("server", "tab3_countriesAnalytics_Server.R"), local = TRUE)
  
  # Used For Testing Purpose
  # Shiny app will automatically stop running whenever the browser tab (or any session) is closed.
  # session$onSessionEnded(stopApp)
})#END SHINYAPP Server
