
Shiny.addCustomMessageHandler("CreateTweets", function (tweetsJson) {
    console.log(tweetsJson);

    clearTweets();
	
	var pageSize=15;
	 $('#pagination').twbsPagination({
        totalPages: Math.ceil(tweetsJson.length / pageSize),
        visiblePages: 6,
		hideOnlyOnePage:true,
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

	     //tweetsContent += '<div class="list">';
	     for (var i = startIndex ; i < Math.min(startIndex + pageSize, tweetsJson.length) ; i++) {
	         var tweet = tweetsJson[i];
	         tweetsContent += '<div class="tweet"><time class="createdAt"><a href="#">' + tweet.created_at + '</a></time> <a href="#" class="user"> ' + tweet.screen_name + '</a><p class="tweetContent" >' + tweet.text + '</p></div>';
	     }
	     //tweetsContent += '</div>'
	     $(".tweetsContainer").append(tweetsContent);
	 }
	 function renderSelectedLang() {

	         var selectedLang = $("input[name='selectedLang']:checked").val();

	         if (selectedLang == "ar") {
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


String.prototype.parseHashtag = function() {
	return this.replace(/[#]+[A-Za-z0-9-_]+/g, function(t) {
		var tag = t.replace("#","")
		return '<a href="https://www.example.com/'+ tag + '" target="_blank">' + tag + '</a>';
	});
};



//UnUsed Stuff
function timeDiff(current, previous) {
    
    var msPerMinute = 60 * 1000;
    var msPerHour = msPerMinute * 60;
    var msPerDay = msPerHour * 24;
    var msPerMonth = msPerDay * 30;
    var msPerYear = msPerDay * 365;
    
    var elapsed = current - previous;
    
    if (elapsed < msPerMinute) {
         return Math.round(elapsed/1000) + ' seconds ago';   
    }
    
    else if (elapsed < msPerHour) {
         return Math.round(elapsed/msPerMinute) + ' minutes ago';   
    }
    
    else if (elapsed < msPerDay ) {
         return Math.round(elapsed/msPerHour ) + ' hours ago';   
    }

    else if (elapsed < msPerMonth) {
         return '...' + Math.round(elapsed/msPerDay) + ' days ago';   
    }
    
    else if (elapsed < msPerYear) {
         return '...' + Math.round(elapsed/msPerMonth) + ' months ago';   
    }
    
    else {
         return '...' + Math.round(elapsed/msPerYear ) + ' years ago';   
    }
}

function linkify(inputText) {
    var replacedText, replacePattern1, replacePattern2, replacePattern3;

    //URLs starting with http://, https://, or ftp://
    replacePattern1 = /(\b(https?|ftp):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/gim;
    replacedText = inputText.replace(replacePattern1, '<a href="$1" target="_blank">$1</a>');

    //URLs starting with "www." (without // before it, or it'd re-link the ones done above).
    replacePattern2 = /(^|[^\/])(www\.[\S]+(\b|$))/gim;
    replacedText = replacedText.replace(replacePattern2, '$1<a href="http://$2" target="_blank">$2</a>');

    //Change email addresses to mailto:: links.
    replacePattern3 = /\w+@[a-zA-Z_]+?(?:\.[a-zA-Z]{2,6})+/gim;
    replacedText = replacedText.replace(replacePattern3, '<a href="mailto:$1">$1</a>');

    return replacedText;
}

function agoTimeText(aTime){
var current= new Date().getTime();
var previous= new Date(aTime).getTime();
  var agoTime = timeDiff(current, previous);
  return agoTime;
}

function linkToTweet(aTweetId,aTweetTime){
  var link =  '<a href="';
  link += 'https://twitter.com/mikomatic/status/'
  link += aTweetId
  link +=  '"  target="_blank">';
  link +=  agoTimeText(aTweetTime);
  link +=  '</a>';
  return link;
}
//End UnUsed Stuff
