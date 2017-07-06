observeEvent(input$getUser, {
    req(input$userid)
userTweets <- get_timeline(input$userid, n = 200, max_id = NULL, home = FALSE,
            full_text = TRUE, parse = TRUE, check = TRUE, usr = FALSE,
            token = NULL)

    if (length(userTweets$text) > 1) {
        userTweets <- toJSON(userTweets, pretty = TRUE)
        write(userTweets, "LoggedData/Saved_UserTweets.json")
        session$sendCustomMessage("CreateUserTweets", userTweets)


    }

})


