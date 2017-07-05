$(document).ready(function () {

    //Add Validation to No Tweets Input
    //$('#noTweets').attr('maxlength', 4).prop('required', true);
    noTweets.oninput = function () {
        if (this.value.length > 5)
            this.value = this.value.slice(0, 5);
    }
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


$('.region-button-checkbox').each(function () {

        // Settings
        var $widget = $(this),
            $button = $widget.find('button'),
            $checkbox = $widget.find('input:checkbox'),
            color = $button.data('color'),
            settings = {
                on: {
                    icon: 'fa fa-check-square-o'
                },
                off: {
                    icon: 'fa fa-square-o'
                }
            };

        // Event Handlers
        $button.on('click', function () {
            $checkbox.prop('checked', !$checkbox.is(':checked'));
            $checkbox.triggerHandler('change');
            updateDisplay();
        });
        $checkbox.on('change', function () {
            updateDisplay();
        });

        // Actions
        function updateDisplay() {
            var isChecked = $checkbox.is(':checked');

            // Set the button's state
            $button.data('state', (isChecked) ? "on" : "off");

            // Set the button's icon
            $button.find('.state-icon')
                .removeClass()
                .addClass('state-icon ' + settings[$button.data('state')].icon);

            // Update the button's color
            if (isChecked) {
                $button
                    .removeClass('btn-default')
                    .addClass('btn-' + color + ' active');
            }
            else {
                $button
                    .removeClass('btn-' + color + ' active')
                    .addClass('btn-default')
                    .blur();
            }
        }

        // Initialization
        function init() {

            updateDisplay();

            // Inject the icon if applicable
            if ($button.find('.state-icon').length == 0) {
                $button.prepend('<i class="state-icon ' + settings[$button.data('state')].icon + '"></i> ');
            }
        }
        init();
    });

   
});
