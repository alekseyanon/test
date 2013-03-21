// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require modernizr
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery-datetimepicker
//= require chosen-jquery
//= require bootstrap-dropdown
//= require bootstrap-tooltip
//= require bootstrap-popover
//= require underscore
//= require backbone
//= require smorodina
//= require hamlcoffee
//= require spin
//= require_tree .
//= require leaflet
//= require jquery/jRating.jquery
//= require jquery.Jcrop

var spinnerConfig = {
    lines: 13, // The number of lines to draw
    length: 7, // The length of each line
    width: 4, // The line thickness
    radius: 10, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    color: '#000', // #rgb or #rrggbb
    speed: 1, // Rounds per second
    trail: 60, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: 'auto', // Top position relative to parent in px
    left: 'auto' // Left position relative to parent in px
};

$(function() {
    $(".landmark-descrition-rating").jRating({
      step:true,
      rateMax : 5,
      length : 5,
      bigStarsPath : '/assets/jquery/icons/stars.png',
      smallStarsPath : '/assets/jquery/icons/small.png',
      phpPath : '/ratings',
      onSuccess :function(data, test){
          $(".user-rating").html("");
        },
      onError :function(data, test){
          $(".user-rating").html("<b style='color:red'>Произошла непредвиденная ошибка. Повторите попытку позже.</b>");
        }
    });

    $('#cropbox').Jcrop({
      aspectRatio: 1,
      setSelect: [0, 0, 600, 600],
      onSelect: update,
      onChange: update
    });

});

/*TODO сделать корректно.
Пока работает следующим образом: родительского класса для голосавлки
должно совпадать с названием контроллера объекта за который голосуем*/
function to_vote(voteable_controller, voteable_id, sign) {
  var id = voteable_controller.split("/").pop() + "_" + voteable_id;
  var up = "#" + id + " .up-vote";
  var down = "#" + id + " .down-vote"
  $.ajax({
    type: "POST",
    /*url: "/reviews/"+review_id+"/make_vote",*/
    url: "/"+voteable_controller+"s/"+voteable_id+"/votes",
    data: ({sign: sign}), /*, id: review_id*/
    success: function(data){
      $(up).html(data.positive);
      $(down).html(data.negative);
    },
    error: function(data){
      alert("something wrong")
    },
    datatype: "json"});
}
function to_unvote(voteable_controller, voteable_id) {
  var id = voteable_controller.split("/").pop() + "_" + voteable_id;
  $.ajax({
    type: "POST",
    url: "/"+voteable_controller+"s/"+voteable_id+"/votes/500", /*"/votes/1",*/
    data: ({"_method": "delete"}),
    success: function(data){
      $("#" + id + " .up-vote").html(data.positive);
      $("#" + id + " .down-vote").html(data.negative);
    },
    error: function(data){
      alert("something wrong")
    },
    datatype: "json"});
}

function update(coords) {
  $('#user_crop_x').val(coords.x);
  $('#user_crop_y').val(coords.y);
  $('#user_crop_w').val(coords.w);
  $('#user_crop_h').val(coords.h);
  updatePreview(coords);
};

function updatePreview(coords) {
  return $('#preview').css({
    width: Math.round(100 / coords.w * $('#cropbox').width()) + 'px',
    height: Math.round(100 / coords.h * $('#cropbox').height()) + 'px',
    marginLeft: '-' + Math.round(100 / coords.w * coords.x) + 'px',
    marginTop: '-' + Math.round(100 / coords.h * coords.y) + 'px'
  });
}

function toggleType(link, field) {
    var obj = document.getElementById(field);
    var obj2 = document.getElementById(link);

    if (obj.type == 'text') {
        obj.type = 'password';
        obj2.innerHTML = "показать пароль";
    } else {
        obj.type = 'text';
        obj2.innerHTML = "скрыть пароль";
    }
}

function complaint(path){
  $('.complaint').html('').load(path+"/complaints/new", function(){
  });
}

