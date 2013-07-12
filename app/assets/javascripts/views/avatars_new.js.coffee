class Smorodina.Views.AvatarNewView extends Smorodina.Views.Base
  el: '#newavatar'

  events:
    'click .file-upload_link'         : 'uploadFileOpen'
    'change .input-hide'              : 'show_preview'

  initialize: ->
    @$file_upload = @$el.find('.input-hide')
    @reader = new FileReader()
    @reader.onload = (e) ->
      $avatar = $('#avatar_preview')
      $avatar.removeAttr('width').removeAttr('height').css('margin', '0')
      image = new Image
      image.src = e.target.result
      image.onload = ->
        h = this.height
        w = this.width
        if w > h
          margin_direct = 'margin-left'
          margin_size = (1 - w/h)*50
          scale = 100/h
        else
          margin_direct = 'margin-top'
          margin_size = (1 - h/w)*50
          scale = 100/w
        $avatar.attr {src: this.src, width: w*scale, height: h*scale}
        $avatar.css(margin_direct, margin_size)

  uploadFileOpen: (e) ->
    e.preventDefault()
    @$file_upload.click()

  show_preview: ->
    files = @$file_upload[0].files
    if files
      @reader.readAsDataURL files[0]
