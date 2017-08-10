tabPanel(
  "Countires",
  tags$head(
    includeCSS("www\\css\\CountriesTab.css"),
    tags$script(src = "js\\tab3_countriesAnalytics.js"),
    tags$script(src = "js\\tab3_countriesAnalytics_R.js")
  ),
  
  sidebarLayout(# Sidebar with a slider input
    sidebarPanel(
      selectizeInput(
        "arabCountries",
        "Arab Countries : ",
        choices = getArabCountriesNames(),
        multiple = T,
        select = getArabCountriesNames(),
        options = list(placeholder = "Select Arab County/Countires",
                       plugins = list("remove_button"))
      )
    ),
  
  # Show a plot of the generated distribution
  mainPanel(
   # htmlTemplate("www\\html\\countriesAnalytics.html", document_ = F)
    plotlyOutput("arabCountriesPieChart")  #%>% withSpinner()
  )
)

)#End Tab User Profile
