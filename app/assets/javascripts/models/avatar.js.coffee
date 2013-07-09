class Smorodina.Models.Avatar extends Backbone.Model
  initialize: ->
    $('.file-upload_link').on 'click', (e) ->
      e.preventDefault()
      $('#newavatar').find('.input-hide').click()

  readURL = (input) ->
    if input.files and input.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        $("#avatar_preview").attr "src", e.target.result
    reader.readAsDataURL input.files[0]

  $(".input-hide").change ->
    readURL this
