$(document).ready ->
  $(".file-hide").fileupload
    uploadTemplateId: null,
    downloadTemplateId: null,
    uploadTemplate: (o) ->
      ""
    downloadTemplate: (o) ->
      ""
    add: (e, data) ->
      $.each data.files, (index, file) ->
        $(".fileinput-description").html file.name
        reader = new FileReader
        reader.onload = (e) ->
          $("#preview").attr "src", e.target.result
          $("div.fileinput").hide()
          $(".subm").removeAttr "disabled"
          $(".subm").click (event) ->
            event.preventDefault()
            jqXHR = data.submit().success((result, textStatus, jqXHR) ->
              console.log "success"
            ).error((jqXHR, textStatus, errorThrown) ->
              console.log $.parseJSON(jqXHR.responseText).errors.toSource()
              console.log errorThrown
            ).complete((result, textStatus, jqXHR) ->
              $("#newimage").modal show: false
              location.reload()
            )
        reader.readAsDataURL file
      
  $(".fileinput-button").click (e) ->
    e.preventDefault()
    $(".file-hide").click()
  
  $(".uploadtype").change ->
    $("#preview").attr "src", ""
    $(".subm").unbind()
    $(".subm").attr "disabled", "disabled"
    if $(this).val() is "pc"
      $(".fileinput-url").hide()
      $('.file-url').val ""
      $(".fileinput").show()
    else
      $(".fileinput").hide()
      filec = $(".file-hide")
      newfilec = filec.clone true
      filec.replaceWith newfilec
      $(".fileinput-description").html "Файл не выбран"
      $(".fileinput-url").show()
  $(".fileinput-url-button").click (e) ->
    e.preventDefault()
    $("#preview").attr "src", $('.file-url').val()
    $(".fileinput-url").hide()
    $(".subm").removeAttr "disabled"
    $("#new_image").submit (event) ->
      event.preventDefault()
      formData = $("#new_image").serializeArray()
      $form = $(this)
      file_url = $('.file-url').val()
      url = $form.attr "action"
      $.ajax(
        type: "POST"
        url: url
        data: formData
      ).done (msg) ->
         $("#newimage").modal show: false
         location.reload()
              