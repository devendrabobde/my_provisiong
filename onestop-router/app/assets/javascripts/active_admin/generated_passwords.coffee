$ ->
  $('.generated_password .generate_password_button').click ->
    password_field = $(this).attr('data-update')

    $.post('/passwords').success((password) ->
      $(password_field).val(password)
    ).error(->
      alert("Error fetching new password. Please try again or contact support.")
    )

  $('.generated_password .show_password').click ->
    password_field = $($(this).attr('data-show'))
    text_field = $('<input type="text">')

    for attribute in ['name', 'id', 'class', 'size', 'maxlength']
      text_field.attr(attribute, password_field.attr(attribute))

    text_field.val(password_field.val())

    password_field.replaceWith(text_field)
    $(this).remove()
