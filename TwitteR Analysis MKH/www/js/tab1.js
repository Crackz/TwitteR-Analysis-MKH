$(document).ready(function () {

    //Add Validation to No Tweets Input
    $('#noTweets').attr('maxlength', 4).prop('required', true);

    //Listen For Enter key if button is disabled then dont work 
    $(document).keypress(function (e) {
        if ($('#btnAnalyze').prop('disabled')) return
        else {
            if (e.which == 13 || e.keyCode == 13) {
                $("#btnAnalyze").click();
            }
        }
	});
    //On moving slider value of notweet input will be changed..
	$("#noTweetsSlider").on("change", function () {
	    var $this = $(this),
         value = $this.prop("value");
	    if (!isNaN(value))
	        document.getElementById("noTweets").value = value;
	});

    //On changing value if not valid color in red
	$("#noTweets").on("change", function () {
	    if ($(this).val() == "" || $(this).val() < 100 ) {
	        $(this).css({
	            "border-color": "#b03535",
	            "box-shadow": "0 0 5px #d45252"
             
	        });
	    }
	    else {
	        $(this).css({
	            "border-color": "",
	            "box-shadow": ""
	        });
	    }
    });

});
