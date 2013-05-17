#This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require modernizr
#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require jquery-datetimepicker
#= require chosen-jquery
#= require moment
#= require bootstrap
#= require underscore
#= require backbone
#= require smorodina
#= require hamlcoffee
#= require spin
#= require_tree .
#= require leaflet
#= require jquery.Jcrop

# ------------------------------------------------------------------------------------------------------------------ 

#TODO сделать корректно.
#Пока работает следующим образом: родительского класса для голосавлки
#должно совпадать с названием контроллера объекта за который голосуем
window.to_vote = (voteable_controller, voteable_id, sign, tag) ->
  id = voteable_controller.split("/").pop() + "_" + voteable_id
  params = sign: sign
  if tag.length > 0
    id = tag + "_geo_" + id
    params =
      sign: sign
      voteable_tag: tag
  up = "#" + id + " .up-vote"
  down = "#" + id + " .down-vote"
  $.ajax
    type: "POST"
    url: "/#{voteable_controller}s/#{voteable_id}/votes.json"
    data: (params)
    success: (data) ->
      $(up).html data.positive
      $(down).html data.negative

    error: (data) ->
      alert "something wrong"

    datatype: "json"

window.to_unvote = (voteable_controller, voteable_id, tag) ->
  id = voteable_controller.split("/").pop() + "_" + voteable_id
  params = _method: "delete"
  if tag.length > 0
    id = tag + "_geo_" + id
    params =
      _method: "delete"
      voteable_tag: tag
  $.ajax
    type: "POST"
    url: "/#{voteable_controller}s/#{voteable_id}/votes/500.json" #"/votes/1",
    data: (params)
    success: (data) ->
      $("#" + id + " .up-vote").html data.positive
      $("#" + id + " .down-vote").html data.negative

    error: (data) ->
      alert "something wrong"

    datatype: "json"

update = (coords) ->
  $("#user_crop_x").val coords.x
  $("#user_crop_y").val coords.y
  $("#user_crop_w").val coords.w
  $("#user_crop_h").val coords.h
  updatePreview coords
updatePreview = (coords) ->
  $("#preview").css
    width: Math.round(100 / coords.w * $("#cropbox").width()) + "px"
    height: Math.round(100 / coords.h * $("#cropbox").height()) + "px"
    marginLeft: "-" + Math.round(100 / coords.w * coords.x) + "px"
    marginTop: "-" + Math.round(100 / coords.h * coords.y) + "px"

window.toggleType = (link, field) ->
  obj = document.getElementById(field)
  obj2 = document.getElementById(link)
  if obj.type is "text"
    obj.type = "password"
    obj2.innerHTML = "показать пароль"
  else
    obj.type = "text"
    obj2.innerHTML = "скрыть пароль"
window.complaint = (path) ->
  $(".complaint").html("").load path + "/complaints/new"

window.get_object = (id, teaser, callback) ->
  url = "/api/objects/" + id
  url += "?teaser=1" if teaser
  $.getJSON url, {}, callback

new Smorodina.Routers.Global
router = new Smorodina.Routers.Global
router.route "events", "events", Smorodina.Pages.Events
router.route "events/search", "events", Smorodina.Pages.Events
router.route "objects/search", "geo_objects", Smorodina.Pages.GeoObjects
router.route "", "index", Smorodina.Pages.Index
router.route "objects/:object_name/images/:image_id", "image_show", Smorodina.Pages.ImageShow
router.route "images/:image_id", "image_show", Smorodina.Pages.ImageShow
router.route "objects/:object_name/images", "images_index", Smorodina.Pages.ImagesIndex
router.route "objects/:object_name/images#objects/:hash_object_name/images/:hash_image_id", "images_index_hash", Smorodina.Pages.ImageShowWindow
Backbone.history.start hashChange: false

$ ->
  $("#cropbox").Jcrop
    aspectRatio: 1
    setSelect: [0, 0, 600, 600]
    onSelect: update
    onChange: update

  $("form").on "click", ".remove_fields", (event) ->
    $(this).closest("fieldset").hide()
    event.preventDefault()

  $("form").on "click", ".add_fields", (event) ->
    regexp = undefined
    time = undefined
    time = new Date().getTime()
    regexp = new RegExp($(this).data("id"), "g")
    $(this).before $(this).data("fields").replace(regexp, time)
    event.preventDefault()

  $("form").on "click", ".add_input", ->
    time = new Date().getTime()
    $(this).parent().append "<input class='string optional' id='video_url_" + time + "' name='video_urls[" + time + "]' size='50' type='text'><br>"

  $('.modal').on 'hidden', ()->
    $(this).css 'display': "none"

  $('.modal').on 'show', ()->
    $(this).css 'display': "block"

  
  if location.href.match /modal=true/
    $('#regLoginModal').modal('show')
