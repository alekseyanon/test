class Smorodina.Views.AvatarNewView extends Smorodina.Views.Base
  el: '#newavatar'

  events:
    'click .file-upload_link'         : 'uploadFileOpen'
    'change .input-hide'              : 'show_preview'

  initialize: ->
    @$file_upload = @$el.find('.input-hide')
    @reader = new FileReader()
    @reader.onload = (e) ->
      console.log 'image loaded'
      src = e.target.result
      console.log src
      img = new Image
      img.src = src
      h = img.height
      w = img.width
      console.log 'size'
      console.log(h)
      console.log(w)
      console.log 'scale'
      scale = (w > h ? 100/h : 100/w)
      console.log scale
      img.width = w*scale
      img.height = h*scale
      $('#previewav').html img
      alert 2
      console.log img.width
      console.log img.height
      $("#avatar_preview").attr "src", img.src
      console.log 'second loggin'
      im = $("#avatar_preview")[0]
      console.log im.width
      console.log im.height
      h = im.height
      w = im.width
      scale = if w > h then 100/h else 100/w
      console.log scale
      console.log w*scale
      console.log h*scale
      $("#avatar_preview").attr "width", w*scale
      $("#avatar_preview").attr "height", h*scale

  uploadFileOpen: (e) ->
    e.preventDefault()
    @$file_upload.click()

  show_preview: ->
    files = @$file_upload[0].files
    if files
      @reader.readAsDataURL files[0]
