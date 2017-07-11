observe({
    toggleState("getUser", isTruthy(input$userId))
})

getUserInfo <- function(user) {
    userInfo<- lookup_users(user)
    if (!is.na(userInfo$user_id[1])) {
        return(userInfo)
    } else {
        stop("Didnt' find user !")
    }
}

getUserTweets <- function(user) {
    userTweets <- get_timeline(user)
    if (!is.na(userTweets$text[1])) {
        return(userTweets)
    } else {
        stop("Didnt' find user !")
    }
}

observeEvent(input$getUser, {
req(input$userId)
 withBusyIndicatorServer("getUser", {
    userInfoJson <- toJSON(getUserInfo(input$userId), pretty = TRUE)
    if (validate(userInfoJson)) {
        write(userInfoJson, "LoggedData/Saved_UserInfo.json")
        print("User Info have Saved..")
        session$sendCustomMessage("CreateUserInfo", userInfoJson)

    } else stop("Couldn't Convert userInfo to json")
    userTweets <- toJSON(getUserTweets(input$userId), pretty = TRUE)
    if (validate(userTweets)) {
        write(userTweets, "LoggedData/Saved_User_Tweets.json")
        print("User Tweets have Sent")
        session$sendCustomMessage("CreateUserTweets", userTweets)
    } else stop("Couldn't Convert userTweets to json")

 })
})


