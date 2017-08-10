profile<- reactiveValues(info=NULL,tweets=NULL)

observe({
    toggleState("getUser", isTruthy(input$userId))
})

getUserInfo <- function(user) {
    userInfo<- lookup_users(user)
    if (!is.na(userInfo$user_id[1])) {
        return(userInfo)
    } else {
        stop("couldn't find user !")
    }
}

getUserTweets <- function(user) {
  twitterTimeLineLimit <- 1000
  
    userTweets <- get_timeline(user, n = twitterTimeLineLimit)
    if (!is.na(userTweets$text[1])) {
        return(userTweets)
    } else {
        stop("couldn't get user tweets !")
    }
}


observeEvent(input$getUser, {
  req(input$userId)
  withBusyIndicatorServer("getUser", {
    profile$info <- getUserInfo(input$userId)
    userInfoJson <- toJSON(profile$info, pretty = TRUE)
    if (validate(userInfoJson))
      session$sendCustomMessage("CreateUserInfo", userInfoJson)
    else
      stop("Couldn't Convert userInfo to json")
    
    profile$tweets <- getUserTweets(input$userId)
    userTweetsJson <- toJSON(profile$tweets, pretty = TRUE)
    if (validate(userTweetsJson)) {
      session$sendCustomMessage("CreateUserTweets", userTweetsJson)
    } else
      stop("Couldn't Convert userTweets to json")
    
    mostUsedWords<- getMostUsedWords(profile$tweets$text)
    showProfileWordCloud(mostUsedWords)
    showProfileWordCloudAsBarChart(mostUsedWords)
  })
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
    print(head(mostUsedWords, 10))
    return(mostUsedWords)
}


observeEvent(input$requestUserAnalysis, {
    updateNavbarPage(session, "tabs", selected = "Profile")
    updateTextInput(session, "userId", value = input$requestUserAnalysis[1])
    session$sendCustomMessage("simulateButtonClick", "#getUser")
})