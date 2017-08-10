tabPanel("Profile",
    tags$head(
         includeCSS("www\\css\\ProfileTab.css"),
         includeCSS("www\\css\\lightbox.min.css"),
         tags$script(src = "js\\lightbox.min.js"),
         tags$script(src = "js\\tab2_UserProfile.js"),
         tags$script(src = "js\\tab2_UserProfile_R.js")
         ),
           htmlTemplate("ui\\UIHTML\\profile.html", document_ = F) 
      
)#End Tab User Profile