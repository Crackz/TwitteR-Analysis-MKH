tabPanel(
  "Countires",
  tags$head(
    includeCSS("www\\css\\tab3.css"),
    tags$script(src = "js\\tab3_countriesAnalytics.js"),
    tags$script(src = "js\\tab3_countriesAnalytics_R.js")
  ),
  
  sidebarLayout(
    # Sidebar with a slider input
    sidebarPanel(
      selectizeInput(
        "arabCountries",
        "Arab Countries : ",
        choices = getArabCountriesNames(),
        multiple = T,
        select= getArabCountriesNames(),
        options = list(
          placeholder = "Select Arab County/Countires",
          plugins = list("remove_button")
        )
      ),
      selectizeInput(
        "foriegnCountries",
        "Foreign Countries: ",
        choices = getForiegnCountriesNames(),
        multiple = T,
        options = list(
          create = TRUE,
          placeholder = "Enter your search query",
          closeAfterSelect = T,
          createOnBlur = T,
          maxItems = 5,
          plugins = list("remove_button", "drag_drop")
        )
      )
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      htmlTemplate("www\\html\\countriesAnalytics.html", document_ = F)
    )
  )
  
)#End Tab User Profile
