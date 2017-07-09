

getUserInfo <- function(user) {
    userInfo<- lookup_users(user)
    if (!is.na(userInfo$user_id)) {
        print("User is not null..")
        return(userInfo)
    } else {
        return("Didnt' find user !")
    }
}


observeEvent(input$getUser, {
req(input$userId)
    userInfoJson <- toJSON(getUserInfo(input$userId), pretty = TRUE)
    if (validate(userInfoJson)) {
        print("Valide User Info Json..")
        write(userInfoJson, "LoggedData/Saved_UserTweets.json")
        session$sendCustomMessage("CreateUserInfo", userInfoJson)

    }

})


