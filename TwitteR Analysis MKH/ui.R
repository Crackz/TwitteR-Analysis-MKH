shinyUI(
  tagList( # Tag Container Created exclusively to include Externel libraries
    useShinyjs(),
    includeCleave(),
    #themeSelector(),
    HTML('<meta charset="UTF-8">'), # To make browser show any language,
    navbarPage(
      title="Twitter Analysis",
      collapsible = T,inverse = F, fluid = T, #selected = "Trends", 
      #---------------------------------------- TAB 1 Twitter Mining --------------------------------------#
      source(file.path("ui", "tab1_MiningTweets_UI.R"), local = TRUE)$value,
       source(file.path("ui", "tab2_UserTimeline_UI.R"), local = TRUE)$value
      
      #---------------------------------------- TAB 2 GetTrends -------------------------------------------#
      #source(file.path("ui", "tab2_GetTrends_UI.R"), local = TRUE)$value

        
      #source(file.path("ui", "tab3_UserTimeline_UI.R"), local = TRUE)$value
      
    )#End NavBar
  )#End Tag Container Created exclusively to extra libraries
  
  
)