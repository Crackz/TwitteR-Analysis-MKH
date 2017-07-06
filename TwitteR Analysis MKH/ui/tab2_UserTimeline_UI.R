tabPanel("User Timeline",
    tags$head(
         includeCSS("www\\css\\timeliner.min.css"),
         tags$script(src = "js\\timeliner.min.js")
    ),
sidebarLayout(
    sidebarPanel(
                tags$h1(id = "userTimelineHeader", "User Timeline", class = "text-center"),
                tags$hr(),
                textInput("userid","UserID :","youm7"),
                actionButton("getUser","Get User")
        ),
            
    mainPanel(
          #div for rendering our tweets to it
          tags$div(class = "userTweetsContainer", id = "tweetsContainerID"),

          #Pagination for our tweets (page 1 2 3 4 ) to render to it through our shinytweets.js
          HTML("<ul id=\"userPagination\" class=\"pagination-md\"></ul>")

          #tags$div(id="timeline",class="timeline-container")
          )
    )   
)#End Tab UserTimeline