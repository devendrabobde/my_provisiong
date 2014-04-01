(function($) {
    if (!$.OneStop) {
        $.OneStop = {};
    }

    $.OneStop.COAS = {
        init: function() {
            $("#edit_cao").validate(
            {
                rules: {
                    "cao[email]": {
                      email: true,
                      required: true
                    },
                    "cao[password]": {
                        minlength: 8,
                        required: true
                    },
                    "cao[password_confirmation]": {
                        required: true,
                        equalTo: "#cao_password"
                    }
                },
                messages: {
                  "cao[password_confirmation]": {
                        required: "Required",
                        equalTo: "New Password Doesn't Match"
                    }
                },
                highlight: function(label) {
                    $(label).parent().find('.valid').each(function(){
                        $('label[class^="valid"]').remove();
                    });
                },
                success: function(label) {
//                    if(label.text('OK!').parent().find('.valid').html() == null) {
//                        label.removeClass('error').addClass('valid');
//                    } else {
//                        label.remove();
//                    }
                }
            });

            $("#edit_cao").validate().form();
            $('label[class^="error"]:not(.valid)').remove();
    
        }
    };
    $(window).load($.OneStop.COAS.init);
})(jQuery);
