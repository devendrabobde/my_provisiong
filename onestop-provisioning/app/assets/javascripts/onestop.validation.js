/*
 * onestop.validation.js file will contain all the inline javascript validation.
 * 
 */
(function($) {
    if (!$.OneStop) {
        $.OneStop = {};
    }

    $.OneStop.COAS = {
        init: function() {
            'use strict'

            
            $.validator.addMethod("alpha", function(value,element)
                {
                    return this.optional(element) || /^[a-z]+$/i.test(value);
                }, "Letters only");


            // COA's account setting page inline validation.
            $("#edit_cao").validate(
            {
                rules: {
                    "cao[email]": {
                        email: true,
                        required: true
                    },
                    "cao[password]": {
                        minlength: 6,
                        required: true
                    },
                    "cao[password_confirmation]": {
                        required: true,
                        equalTo: "#cao_password"
                    }
                },
                messages: {
                    "cao[email]": {
                        required: "Email can't be blank."
                    },
                    "cao[password]": {
                        minlength: "Password should be 8 characters.",
                        required: "Password can't be blank."
                    },
                    "cao[password_confirmation]": {
                        required: "Password Confirmation can't be blank.",
                        equalTo: "New Password Doesn't Match"
                    }
                },
                highlight: function(label) {
                    $(label).parent().find('.valid').each(function(){
                        $('label[class^="valid"]').remove();
                    });
                },
                success: function(label) {
                },
                errorElement: "span"
            });


            // Super Admin COA's account creation inline validation.
            $("#new-organization, #edit-organization").validate(
            {
                rules: {
                    "organization[name]": {
                        required: true
                    },
                    "organization[zip_code]": {
                        required: true,
                        number: true
                    },
                    "organization[postal_code]": {
                        required: true,
                        number: true
                    },
                    "organization[contact_first_name]": {
                        required: true,
                        minlength: 1,
                        maxlength: 60,
                        alpha: true
                    },
                    "organization[contact_last_name]": {
                        required: true,
                        minlength: 1,
                        maxlength: 60,
                        alpha: true
                    },
                    "organization[contact_email]": {
                        required: true,
                        email: true,
                        minlength: 7,
                        maxlength: 100
                    }
                },
                messages: {
                    "organization[contact_email]": {
                        required: "Email can't be blank.",
                        email: "Email format is invalid."
                    },
                    "organization[contact_last_name]": {
                        required: "Last Name can't be blank.",
                        alpha: "Please enter letters only."
                    },
                    "organization[contact_first_name]": {
                        required: "First Name can't be blank.",
                        alpha: "Please enter letters only."
                    },
                    "organization[name]": {
                        required: "Organization Name can't be blank."
                    },
                    "organization[zip_code]": {
                        required: "Zip Code can't be blank.",
                        number: "Zip Code must contain digits only."
                    },
                    "organization[postal_code]": {
                        required: "Postal Code can't be blank.",
                        number: "Postal Code must contain digits only."
                    }
                },
                highlight: function(label) {
                    $(label).parent().find('.valid').each(function(){
                        $('span[class^="valid"]').remove();
                    });
                },
                errorElement: "span"
            });


            // COA's account creation
            $("#new_cao, #edit-coa").validate({
                rules: {
                    "cao[first_name]": {
                        required: true,
                        minlength: 1,
                        maxlength: 60,
                        alpha: true
                    },
                    "cao[last_name]": {
                        required: true,
                        minlength: 1,
                        maxlength: 60,
                        alpha: true
                    },
                    "cao[username]": {
                        required: true,
                        minlength: 3,
                        maxlength: 60
                    },
                    "cao[email]": {
                        email: true,
                        required: true,
                        minlength: 7,
                        maxlength: 100
                    },
                    "cao[password]": {
                        required: true,
                        minlength: 3,
                        maxlength: 60
                    }
                },
                messages: {
                    "cao[first_name]": {
                        required: "First name can't be blank.",
                        alpha: "Please enter letters only."
                    },
                    "cao[last_name]": {
                        required: "Last name can't be blank.",
                        alpha: "Please enter letters only."
                    },
                    "cao[username]": {
                        required: "Username can't be blank."
                    },
                    "cao[email]": {
                        email: "Email format is invalid.",
                        required: "Email can't be blank."
                    },
                    "cao[password]": {
                        required: "Password can't be blank."
                    }

                },
                highlight: function(label) {
                    $(label).parent().find('.valid').each(function(){
                        $('span[class^="valid"]').remove();
                    });
                },
                errorElement: "span"
            });



            // Forget password
            $("#forget-password").validate({
                rules: {
                    "cao[email]": {
                        required: true,
                        email: true
                    }
                },
                message: {
                    "cao[email]": {
                        required: "Email can't be blank."
                    }
                }
            });

            
            $('span[class^="error"]:not(.valid)').remove();

        }
    };
    $(window).load($.OneStop.COAS.init);
})(jQuery);
