tabPanel("Profile",
    tags$head(
         includeCSS("www\\css\\tab2.css"),
         includeCSS("www\\css\\lightbox.min.css"),
         tags$script(src = "js\\lightbox.min.js"),
         tags$script(src = "js\\tab2_UserProfile.js"),
         tags$script(src = "js\\tab2_UserProfile_R.js")
         ),
           htmlTemplate("www\\html\\profile.html", document_ = F) 
        
)#End Tab User Profile