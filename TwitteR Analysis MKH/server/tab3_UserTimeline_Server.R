output$userinfo <- renderTable({
    data <- lookup_users(input$username , token = NULL, parse = TRUE, tw = TRUE,
    clean_tweets = F, as_double = FALSE)

    if (is.null(data$id)) {
        data <- userInfo(token, "narendramodi")
    }
    pic <- profile_pic
    if (!is.null(pic)) cbind(pic = as.character(img(src = pic)), data.frame(data))
}, sanitize.text.function = function(x) x)

output$usertweets <- renderTable({
    data <- userTweets(token, input$username, count = input$counter)
    if (length(data) == 0) {
        data <- userTweets(token, "narendramodi")
    }
    data.frame(`Recent Tweets` = data)
})