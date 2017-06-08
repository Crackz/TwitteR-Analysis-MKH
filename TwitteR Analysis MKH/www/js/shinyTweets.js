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

