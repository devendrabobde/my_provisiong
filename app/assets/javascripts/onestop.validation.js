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
                return this.optional(element) || /^[A-Za-z\s*\u00C0-\u017F]+$/i.test(value);
            }, "Letters only");

            $.validator.addMethod("passwordValidation", function(value,element)
            {
                return this.optional(element) || /^(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{8,16}$/i.test(value);
            }, "Password must include at least 1 special character and one digit.");


            // COA's account setting page inline validation.
            $("#edit-personal-info").validate(
            {
                rules: {
                    "cao[first_name]": {
                        required: true,
                        minlength: 3,
                        maxlength: 60,
                        alpha: true
                    },
                    "cao[last_name]": {
                        required: true,
                        minlength: 3,
                        maxlength: 60,
                        alpha: true
                    },
                    "cao[email]": {
                        email: true,
                        required: true
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
                    "cao[email]": {
                        required: "Email can't be blank."
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


            $("#edit-change-password").validate(
            {
                rules: {
                    "cao[password]": {
                        passwordValidation: true
                    },
                    "cao[password_confirmation]": {
                        equalTo: "#cao_password"
                    }
                },
                messages: {
                    "cao[password]": {
                        passwordValidation: "Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character"
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
                        required: true,
                        minlength: 6,
                        maxlength: 60
                    },
                    "organization[address1]": {
                        required: true
                    },
                    "organization[city]": {
                        required: true,
                        alpha: true
                    },
                    "organization[state_code]": {
                        required: true
                    },
                    "organization[zip_code]": {
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
                    },
                    "organization[contact_phone]": {
                        number: true,
                        minlength: 10,
                        maxlength: 10
                    },
                    "organization[contact_fax]": {
                        number: true,
                        minlength: 10,
                        maxlength: 10
                    }
                },
                messages: {
                    "organization[address1]": {
                        required: "Address1 can't be blank."
                    },
                    "organization[city]": {
                        required: "City can't be blank.",
                        alpha: "Please enter letters only."
                    },
                    "organization[state_code]": {
                        required: "You have to select a state."
                    },
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
                    }
                },
                highlight: function(label) {
                    $(label).parent().find('.valid').each(function(){
                        $('span[class^="valid"]').remove();
                    });
                },
                errorElement: "p"
            });


            // COA's account creation
            $("#new_cao, #edit-coa").validate({
                rules: {
                    "cao[first_name]": {
                        required: true,
                        minlength: 3,
                        maxlength: 60,
                        alpha: true
                    },
                    "cao[last_name]": {
                        required: true,
                        minlength: 3,
                        maxlength: 60,
                        alpha: true
                    },
                    "cao[username]": {
                        required: true,
                        minlength: 6,
                        maxlength: 60
                    },
                    "cao[email]": {
                        email: true,
                        required: true,
                        minlength: 7,
                        maxlength: 100
                    },
                    "cao[password]": {
                        passwordValidation: true,
                        //required: true,
                        rangelength: [8, 16]
                    },
                    "cao[password_confirmation]": {
                        equalTo: "#cao_password"
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
                        passwordValidation: "Minimum 8 and Maximum 16 characters at least 1 Alphabet, 1 Number and 1 Special Character",
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
