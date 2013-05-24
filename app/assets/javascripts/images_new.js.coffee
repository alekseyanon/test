class Smorodina.Views.ImageNew extends Backbone.View
  el: '#newimage'
  
  events:
    'click .fileinput-button'         : 'uploadOpen'
    'change .uploadtype'              : 'changeUploadType'
    'imageChange #preview'            : 'hideInputs'
    'click .fileinput-url-button'     : 'fileUrlChange'
  
  initialize: ->
    this.render 'uploader_file'
    this.submBindFile()
    this.reader = new FileReader
    this.reader.onload = (e) ->
      $('#preview').attr 'src', e.target.result
      $('#preview').trigger 'imageChange'
  
  fileinputChange: (file) ->
    if file.name.match(/\.(jpg|jpeg|gif|png)$/)
      this.$el.find('.fileinput-description').html file.name
      this.reader.readAsDataURL file
    else
      this.$el.find('.fileinput-description').html 'Неправильный формат файла'
    
  fileUrlChange: (e) ->
    e.preventDefault()
    if (url_val = $('.file-url').val()).match /\.(jpg|jpeg|gif|png)$/
      ($preview = $('#preview')).attr 'src', url_val
      $preview.trigger 'imageChange'
  
  hideInputs: -> 
    this.$el.find('.fileinput').hide()
    this.$el.find('.fileinput-url').hide()
    this.$el.find('.subm').removeAttr 'disabled'
    
  
  submBindFile: ->
    $('.subm').unbind()
    th = this
    this.$el.find('.file-hide').fileupload
      uploadTemplateId: null,
      downloadTemplateId: null,
      uploadTemplate: (o) ->
        ''
      downloadTemplate: (o) ->
        ''
      add: (e, data) ->
        $.each data.files, (index, file) ->
          th.fileinputChange(file)
          $('.subm').click (event) ->
            event.preventDefault()
            $(@).attr 'disabled', 'disabled'
            data.submit().complete (result, textStatus, jqXHR) ->
              $('#newimage').modal show: false
              location.reload()
            
  submBindUrl: ->
    $('.subm').unbind()
    $('.subm').click (event) ->
      event.preventDefault()
      $(this).attr 'disabled', 'disabled'
      formData = $('#new_image').serializeArray()
      $form = $('#new_image')
      url = $form.attr 'action'
      $.ajax(
        type: 'POST'
        url: url
        data: formData
      ).done (msg) ->
         $('#newimage').modal show: false
         location.reload()
  
  changeUploadType: ->
    utype = this.$el.find('.uploadtype:checked').val()
    if utype is 'pc'
      this.render 'uploader_file'
      this.submBindFile()
    else
      this.render 'uploader_url'
      this.submBindUrl()
  
  uploadOpen: (e) ->
    e.preventDefault()
    this.$el.find('.file-hide').click()
  
  render: (tmpl_name) ->
    this.$el.find('.subm').attr 'disabled', 'disabled'
    template = JST[tmpl_name]
    this.$el.find('.content').html template
  
$(document).ready ->
  $('#newimage').on 'shown', ->
    new Smorodina.Views.ImageNew
