tabPanel("Trends" , 
  tags$head(
            includeCSS("www\\css\\tab2.css")
           ),
  div(class="outer",
      leafletOutput("trendsMap",width = "100%",height="100%")
     
      
      # absolutePanel(top = 10, right = 10 ,class="panel panel-default",
       #             selectInput("countrySelector", "Country:",choices=c("",as.character(sort(countriesInfo@data$countriesNames))),selected = "")
        
      ),
       absolutePanel(id = "trendsControls", class = "panel panel-default", fixed = TRUE,
                     draggable = TRUE, top = 80, right = 20, height = "auto", width="350px",
                     h3("Get Trends Of "),
                     selectInput("countrySelector", "Country :",choices=c("",as.character(sort(countriesInfo@data$countriesNames))),selected = ""),
                     actionButton("getTrends",label="Show Trends",class="btn-primary")
                     
                     
                     ),#End of Floating TrendsMap Options Panel
  
           hidden(
                absolutePanel(id = "trendsPanel", class = "panel panel-default", fixed = TRUE,
                        draggable = T , top = 80, left = 50, height = "100%",width="25%",
                        actionButton("closeTrendsPanel","",icon = icon("close")),
                        lapply(1:50, function(i) {
                          uiOutput(paste0('trend', i))
                        })
                          
                        )
                
                
                ,plotOutput("trendsResult2")
             #wellPanel(id = "trendsPanel", fixed = TRUE,
                            #             draggable = F , top = 80, left = 50, height = "80%",width="70%" )
            # plotOutput("trendsResults")
             
             #tableOutput('trendsResults'),
             
             ) 
      
)#End Tab Trends
