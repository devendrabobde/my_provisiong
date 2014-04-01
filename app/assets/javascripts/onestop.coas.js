
(function($) {
    if (!$.OneStop) {
        $.OneStop = {};
    }

    $.OneStop.COAS = {
        init: function() {
            'use strict'


            // COA's edit page inline validation.
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
                    "cao[email]": {
                        required: "Email can't be blank."
                    },
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
                }
            });


            if($("#edit_cao").length > 0) {
                $("#edit_cao").validate().form();
                $('label[class^="error"]:not(.valid)').remove();
            }

            // Super Admin COA's account creation inline validation.

            $("#edit-organization").validate(
            {
                debug: true,
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
                        required: true
                    },
                    "organization[contact_last_name]": {
                        required: true
                    },
                    "organization[contact_email]": {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    "organization[contact_email]": {
                        required: "Email can't be blank.",
                        email: "Email format is invalid."
                    },
                    "organization[contact_last_name]": {
                        required: "Last Name can't be blank."
                    },
                    "organization[contact_first_name]": {
                        required: "First Name can't be blank."
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

            if($("#edit-organization").length > 0) {
                console.log($("#edit-organization"));
                $("#edit-organization").validate().form();
                $('span[class^="error"]:not(.valid)').remove();
            }

            $("#new-organization").validate(
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
                        required: true
                    },
                    "organization[contact_last_name]": {
                        required: true
                    },
                    "organization[contact_email]": {
                        required: true,
                        email: true
                    }
                },
                messages: {
                    "organization[contact_email]": {
                        required: "Email can't be blank.",
                        email: "Email format is invalid."
                    },
                    "organization[contact_last_name]": {
                        required: "Last Name can't be blank."
                    },
                    "organization[contact_first_name]": {
                        required: "First Name can't be blank."
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

            if($("#new-organization").length > 0) {
                $("#new-organization").validate().form();
                $('span[class^="error"]:not(.valid)').remove();
            }


            // COA's account creation
            $("#new_cao, #edit-coa").validate({
                rules: {
                    "cao[first_name]": {
                        required: true
                    },
                    "cao[last_name]": {
                        required: true
                    },
                    "cao[username]": {
                        required: true
                    },
                    "cao[email]": {
                        email: true,
                        required: true
                    },
                    "cao[password]": {
                        required: true
                    }
                },
                messages: {
                    "cao[first_name]": {
                        required: "First name can't be blank."
                    },
                    "cao[last_name]": {
                        required: "Last name can't be blank."
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

            if($("#new_cao").length > 0) {
                $("#new_cao").validate().form();
                $('span[class^="error"]:not(.valid)').remove();
            }

            if($("#edit-coa").length > 0) {
                $("#edit-coa").validate().form();
                $('span[class^="error"]:not(.valid)').remove();
            }



        }
    };
    $(window).load($.OneStop.COAS.init);
})(jQuery);
