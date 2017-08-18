shinyUI(tagList(
  # Tag Container Created exclusively to include Externel libraries
  useShinyjs(),
  includeCleave(),
  #shinythemes::themeSelector(),
  # To make browser show any language,
  HTML('<meta charset="UTF-8">'),
  
  tags$head(
    includeCSS("www\\css\\styles.css"),
    tags$script(src = "js\\global.js"),
    tags$script(src = "js\\arrive.min.js")
    
  ),
  
  navbarPage(
    id = "tabs",
    title = "Twitter Analysis",
    collapsible = T,
    inverse = F,
    fluid = T,
    theme = shinytheme("cerulean"),
    selected = "Search",
    #---------------------------------------- TAB 1 Twitter Mining --------------------------------------#
    source(file.path("ui", "tab1_MiningTweets_UI.R"), local = TRUE)$value,
    
    #---------------------------------------- TAB 2 User Analysis -------------------------------------------#
    source(file.path("ui", "tab2_UserProfile_UI.R"), local = TRUE)$value,
    
    #---------------------------------------- TAB 2 User Analysis -------------------------------------------#
    source(file.path("ui", "tab3_countriesAnalytics_UI.R"), local = TRUE)$value
  )#End NavBar
))#End Taglist Container Created exclusively to be able to include extra libraries for shiny)