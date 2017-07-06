tabPanel("User Timeline",
    tags$head(
         includeCSS("www\\css\\timeliner.min.css"),
         includeCSS("www\\css\\style.css")

    ),
    fluidPage(
            div(
                textInput("userId","User ID :",""),
                actionButton ("getUser","Analyze User Profile")
            ),

htmlTemplate("profile.html", name = "profile1")
        )
)#End Tab UserTimeline