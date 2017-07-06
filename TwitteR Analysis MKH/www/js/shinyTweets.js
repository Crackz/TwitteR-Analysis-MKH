Shiny.addCustomMessageHandler("CreateTweets", function (tweetsJson) {
    console.log(tweetsJson);
    clearTweets();
	
	var pageSize=15;
	 $('#pagination').twbsPagination({
        totalPages: Math.ceil(tweetsJson.length / pageSize),
        visiblePages: 6,
		hideOnlyOnePage: true,
        onPageClick: function (event, page) {
            renderTweetsOnPage(page, pageSize);
            renderSelectedLang();
			jQuery("html,body").animate({ scrollTop: 50 }, 300);
		}
	 });


	 function renderTweetsOnPage(page, pageSize) {
	     $(".tweetsContainer").empty();

	     var tweetsContent = "";
	     var startIndex = (page - 1) * pageSize;

         for (var i = startIndex; i < Math.min(startIndex + pageSize, tweetsJson.length); i++) {
	         var tweet = tweetsJson[i];
	         tweetsContent += '<div class="tweet"><time class="createdAt"><a href="#">' + tweet.created_at + '</a></time> <a href="#" class="user"> ' + tweet.screen_name + '</a><p class="tweetContent" >' + tweet.text + '</p></div>';
	     }
	     $(".tweetsContainer").append(tweetsContent);
     }

     function renderSelectedLang() {
         var currentSelectedLang = $("#selectedLang").val();
         if (currentSelectedLang == "Arabic" || currentSelectedLang == "Hebrew" ) {
	        $(".tweet").css("direction", "rtl");
	        $(".createdAt").css({ "left": "1em", "direction": "ltr" });
	        $(".tweetContent").css({ "margin": "0 1% 0 0" });
	     }
	     else {
	        $(".tweet").css("direction", "ltr");
	        $(".createdAt").css("right", "1em");
	        $(".tweetContent").css({ "margin": "0 0 0 1%" });
	     }
	 }
});

function clearTweets() {
    $(".tweetsContainer").empty();
    $('#pagination').twbsPagination('destroy')
}



Shiny.addCustomMessageHandler("CreateUserTweets", function (userTweetsJson) {
    console.log(userTweetsJson);

    var pageSize = 15;
    $('#userPagination').twbsPagination({
        totalPages: Math.ceil(userTweetsJson.length / pageSize),
        visiblePages: 6,
        hideOnlyOnePage: true,
        onPageClick: function (event, page) {
            renderTweetsOnPage(page, pageSize);
            renderSelectedLang();
            jQuery("html,body").animate({ scrollTop: 50 }, 300);
        }
    });


    function renderTweetsOnPage(page, pageSize) {

        var tweetsContent = "";
        var startIndex = (page - 1) * pageSize;

        for (var i = startIndex; i < Math.min(startIndex + pageSize, userTweetsJson.length); i++) {
            var tweet = userTweetsJson[i];
            tweetsContent += '<div class="tweet"><time class="createdAt"><a href="#">' + tweet.created_at + '</a></time> <a href="#" class="user"></a><p class="tweetContent" >' + tweet.text + '</p></div>';
        }
        $(".userTweetsContainer").append(tweetsContent);
    }
    function renderSelectedLang() {
        var currentSelectedLang = $("#selectedLang").val();
        if (currentSelectedLang == "Arabic" || currentSelectedLang == "Hebrew") {
            $(".tweet").css("direction", "rtl");
            $(".createdAt").css({ "left": "1em", "direction": "ltr" });
            $(".tweetContent").css({ "margin": "0 1% 0 0" });
        }
        else {
            $(".tweet").css("direction", "ltr");
            $(".createdAt").css("right", "1em");
            $(".tweetContent").css({ "margin": "0 0 0 1%" });
        }
    }
});


























//Shiny.addCustomMessageHandler("CreateUserTweets", function (userTweetsJson) {
//    console.log(userTweetsJson);
//    clearUserTweets();

//    tweetsContent += '<div class="tweet"><time class="createdAt"><a href="#">' + tweet.created_at + '</a></time> <a href="#" class="user"> ' + tweet.screen_name + '</a><p class="tweetContent" >' + tweet.text + '</p></div>';




//    //var tweetsYears = [];
//    //var userTweetsContent = ``;

//    //for (var i = 0; i < userTweetsJson.length; i++) {
//    //    var userTweet = userTweetsJson[i];
//    //    var userTweetYear = new Date(userTweet.created_at).getFullYear();
        
//    //    if (tweetsYears.includes(userTweetYear)) {
//    //        console.log("i was here");
//    //        tweetsYears.push(userTweetYear);
//    //    }
//    //}

//    //console.log(tweetsYears);
//    //for (var i = 0; i < userTweetYear.length; i++) {

//    //    userTweetsContent += `
//    //        <div class="timeline-wrapper">
//    //                    <h2 class="timeline-time">${tweetsYears[i]}</h2>

//    //                    <dl class="timeline-series">
//    //     `


//    //    for (var j = 0; j < userTweetsJson.length; j++) {
//    //        var userTweet = userTweetsJson[i];
//    //        var userTweetYear = new Date(userTweet.created_at).getFullYear();
//    //        if (userTweetYear === tweetsYears[i]) {
//    //            userTweetsContent += `
//    //                <dt class="timeline-event"><a>${userTweet.created_at}</a></dt>
//    //                    <dd class="timeline-event-content" id="event01EX">
//    //                        <p>${userTweet.text}</p>
//    //                </dd>
//    //            `
//    //        }

//    //    }
//    //    userTweetsContent += `
//    //                </dl>
//    //        </div>
//    //    `



//    //    //var userTweet = userTweetsJson[i];
//    //    //var userTweetYear = new Date(userTweet.created_at).getFullYear();
//    //    //for (var j = 0; j < userTweetYear.length; j++) {
//    //    //    if (userTweetYear[i] == userTweetYear)
//    //    //    userTweetsContent += `
//    //    //    <div class="timeline-wrapper">
//    //    //                <h2 class="timeline-time">${(new Date(userTweet.created_at)).getFullYear()}</h2>

//    //    //                <dl class="timeline-series">

//    //    //                        <dt class="timeline-event"><a>${(new Date(userTweet.created_at)).getMonth()}</a></dt>
//    //    //                        <dd class="timeline-event-content">
//    //    //                                <p>${userTweet.text}</p>
//    //    //                        </dd>

//    //    //                </dl>
//    //    //        </div>
//    //    //    `
//    //    //}
//    //}
//    //$("#timeline").append(userTweetsContent);
//    //$.timeliner({});
//});

//function clearUserTweets() {
 
//}