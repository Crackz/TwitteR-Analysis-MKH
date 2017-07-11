var userInfo;
Shiny.addCustomMessageHandler("CreateUserInfo", function (userInfo) {
    $("#userInfoTable").empty();
    console.log(userInfo, "UserInfo")
    userInfo = userInfo[0];
    this.userInfo = userInfo;

    $("#userProfileImage").attr("src", getPictureURL(userInfo.profile_image_url));
    $("#userProfileImage a").attr("href", getPictureURL(userInfo.profile_image_url));

    var userInfoContent =
        `
        <div style="font-size: 20px; margin: 2px 0 5px 0;">
            <span style="font-size: 16px;">${userInfo.name}</span>
            <span style="font-size: 14px; font-weight: bold;">@${userInfo.screen_name}</span>
            ${JSON.parse(userInfo.verified)? `<span style="padding-left: 10px;"><img src="images/verified.jpg" title="Twitter verified profile" width="15" height="15"></span>`:''}
        </div>

        <div style="margin-bottom: 4px;">
            <span class="label label-black" >${userInfo.statuses_count}</span> tweets
            <span class="label label-info" style="margin-left: 10px;">${userInfo.friends_count}</span> following
            <span class="label label-success" style="margin-left: 10px;">${userInfo.followers_count}</span> followers
            <span class="label label-important" style="margin-left: 10px;">${userInfo.listed_count}</span> listed</div>
        </div>
        <div style="margin-bottom: 2px;">Joined Twitter on <span>${userInfo.created_at}</span> as user #<span id="userId">${userInfo.user_id}</span></div>

        ${ userInfo.description ? `<div style="color:#707070;line-height: 16px; margin: 10px auto; font-family: Georgia, Times New Roman, serif; font-style: italic;">${userInfo.description}</div> `: ''}

        <div style="margin-top:5px;">
            location &nbsp;<span style="margin-right:5px;" class="label label-orange">${userInfo.location}</span>
            language &nbsp;<span style="margin-right:5px;" class="label label-blue">${userInfo.lang}</span>
            timezone &nbsp;<span style="margin-right:5px;" class="label label-purple">${userInfo.time_zone}</span>
        </div<
        `    
    
    $("#userInfoTable").append(userInfoContent);
    $("#userDetailsInfo").css('visibility', 'visible');

    function getPictureURL(profile_image_url) {
        return profile_image_url.replace('_normal', '');
    }
});

Shiny.addCustomMessageHandler("CreateUserTweets", function (userTweets) {
    $("#userTweetsContent").empty();
    console.log(userTweets,"User Tweets");
    var userTweetsContent=``;
    for (var i = 0; i < userTweets.length; i++) {
        var userTweet = userTweets[i];
        userTweetsContent +=
            `
            <div class="userTweet">
                
                <div class="tweetHeader">
                    <div class="goLeft">
                        <span style="font-weight:bold;font-size:12px;">
                            <a href="https://twitter.com/${userTweet.screen_name}" target="_blank" style="color: #333333;">${this.userInfo.name}</a>
                        </span>
                        <span style="font-size: 10px;">@${userTweet.screen_name}</span>
                    </div>
                    <div class="goRight">
                        <span style="padding-left: 10px; padding-right: 10px; font-size: 10px;">${userTweet.created_at} via ${userTweet.source}</span>
                        <img src="images/retweet.png" style="margin-right: 2px;" width="20" height="20" align="absmiddle">
                        <span style="font-size: 10px;color:lightblue;">${userTweet.retweet_count}</span>
                        <img src="images/favorite.png" style="mmargin-right: 2px; margin-left: 5px;" width="20" height="20" align="absmiddle">
                        <span style="font-size: 10px;color:orange;">${userTweet.favorite_count}</span>
                    </div>
                </div>
                <div class="tweetContent">
                    <p>${userTweet.text}<p> 
                </div>
            </div>
           `;
    }
    userTweetsContent += `
        <div class="userTweet">
            <button style="align-self:center;" class="btn btn-primary fa fa-plus-circle">&nbsp;MoreTweets</button>
        </div>
    `
    $('#userTweetsContent').append(userTweetsContent);
    $("#userTweets").css('visibility', 'visible');

});