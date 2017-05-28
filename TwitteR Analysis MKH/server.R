shinyServer(function(input, output,session) {
  
  #-------------------------------------- Shared Tabs --------------------------------------------#
  source(file.path("server", "tabAll_SharedFuns_Server.R"), local = TRUE)$value
  
  #------------------------------------- Twitter Anaylsis TAB 1 ----------------------------------#
  source(file.path("server", "tab1_MiningTweets_Server.R"), local = TRUE)$value
  #source(file.path("server", "tab3_UserTimeline_Server.R"), local = TRUE)$value

  #-------------------------------------# Trends Map TAB 2 ---------------------------------------#
  #source(file.path("server", "tab2_GetTrends_Server.R"), local = TRUE)$value
  
 session$onSessionEnded(stopApp)#Shiny app will automatically stop running whenever the browser tab (or any session) is closed.
  
})#END SHINYAPP Server

