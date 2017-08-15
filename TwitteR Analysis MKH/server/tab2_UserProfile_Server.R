profile<- reactiveValues(info=NULL,tweets=NULL,isRequested=FALSE)

observe({
    toggleState("getUser", isTruthy(input$userId))
})

getProfileInfo <- function(user) {
    userInfo<- lookup_users(user)
    if (nrow(userInfo) > 0) {
        return(userInfo)
    } else {
        stop("couldn't find user !")
    }
}

getProfileTweets <- function(user) {
  twitterTimeLineLimit <- 1000
  
    profileTweets <- get_timeline(user, n = twitterTimeLineLimit)
    if (nrow(profileTweets) > 0) {
        return(profileTweets)
    } else {
      print("i was here..")
        stop("couldn't get user tweets !")
    }
}


observeEvent(input$getUser, {
  req(input$userId)
  # Clear any existing user 
  runjs("ClearUser();")
  
  withBusyIndicatorServer("getUser", {
    if (profile$isRequested)
    {
      profile$isRequested <- FALSE
      profile$name <- input$requestUserAnalysis[1]
    }
    else
      profile$name <- input$userId
    
    print(input$userId)
    
    profile$info <- getProfileInfo(profile$name)
    profileInfoJson <- toJSON(profile$info, pretty = TRUE)
    if (validate(profileInfoJson))
      session$sendCustomMessage("CreateUserInfo", profileInfoJson)
    else
      stop("Couldn't Convert userInfo to json")
    
    if(profile$info$protected){
      runjs("ProtectedProfile();")
      stop("Couldn't Analyze ! Protected Tweets is enabled by this user")
    }
    
    profile$tweets <- getProfileTweets(input$userId)
    profileTweetsJson <- toJSON(profile$tweets, pretty = TRUE)
    if (validate(profileTweetsJson)) {
      session$sendCustomMessage("CreateUserTweets", profileTweetsJson)
    } else
      stop("Couldn't Convert userTweets to json")
    
    profileAnalysis()

  })
})

profileAnalysis<- reactive({
  mostUsedWords<- getMostUsedWords(profile$tweets$text)
  runjs("ShowProfileAnalysis();")
  showProfileWordCloud(mostUsedWords)
  showProfileWordCloudAsBarChart(mostUsedWords)
})


showProfileWordCloud<- function(mostUsedWords){
  output$profileWordCloud <- renderPlot({
    wordcloud(
      words = mostUsedWords$word,
      freq = mostUsedWords$freq,
      min.freq = 1,
      max.words = 50,
      random.order = FALSE,
      rot.per = 0.35,
      colors = brewer.pal(8, "Dark2")
      # wordcloud internally calculates scale(x,y) <- (scale[1] - scale[2]) * normedFreq + scale[2]
      # scale = c(2,3)
    )
  })
}
showProfileWordCloudAsBarChart<- function(mostUsedWords){
  output$profileWordCloudAsBarChart <- renderPlot({
    barplot(mostUsedWords[1:10,]$freq, las = 2, names.arg = mostUsedWords[1:10,]$word,
            col = brewer.pal(8, "Dark2"), main ="Most frequent words",
            ylab = "Word frequencies")
  })
}

# this function takes input of tweets as plain vector text and cleans it up
# cleaning is done by removing unwanted text for analysis
# Input: unprocessed tweets & lang argument  
# Output: cleaned tweets 
cleanTweets<- function(tweetsAsVector, lang="en"){
  
  if(lang != "en")
    stop("Language should be English ! ")
  removeURL = content_transformer(function(x) gsub("(f|ht)tp(s?)://\\S+", "", x, perl=T))
  
  myCorpus <- iconv(tweetsAsVector, "latin1", "ASCII", sub="")
  myCorpus = Corpus(VectorSource(myCorpus))
  myCorpus = tm_map(myCorpus, removeURL)
  myCorpus = tm_map(myCorpus, removeNumbers)
  myCorpus = tm_map(myCorpus, stripWhitespace)
  if(lang== "en")
  {
    myCorpus = tm_map(myCorpus, removePunctuation)
    
    myCorpus = tm_map(myCorpus, content_transformer(tolower))
    
    myCorpus = tm_map(myCorpus, removeWords,c('rt','RT',stopwords('english')))
  }
 #inspect(myCorpus)
  return(myCorpus)
}


getMostUsedWords <- function(userTweets, lang = "en") {
    
    myCorpus<- cleanTweets(userTweets)
    dtm <- TermDocumentMatrix(myCorpus)
    m <- as.matrix(dtm)
    v <- sort(rowSums(m),decreasing=TRUE)
    mostUsedWords <- data.frame(word = names(v),freq=v)
    # print(head(mostUsedWords, 10))
    return(mostUsedWords)
}


observeEvent(input$requestUserAnalysis, {
    updateNavbarPage(session, "tabs", selected = "Profile")
    updateTextInput(session, "userId", value = input$requestUserAnalysis[1])
    profile$isRequested<- TRUE
    session$sendCustomMessage("simulateButtonClick", "#getUser")
})