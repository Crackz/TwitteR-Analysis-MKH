shinyServer(function(input, output,session) {
 
  #------------------------------------- Twitter Anaylsis TAB 1 ----------------------------------#
  source(file.path("server", "tab1_MiningTweets_Server.R"), local = TRUE)
  source(file.path("server", "tab2_UserProfile_Server.R"), local = TRUE)

  #-------------------------------------# Trends Map TAB 2 ---------------------------------------#
  #source(file.path("server", "tab2_GetTrends_Server.R"), local = TRUE)$value
  
 #session$onSessionEnded(stopApp)#Shiny app will automatically stop running whenever the browser tab (or any session) is closed.
  
})#END SHINYAPP Server

