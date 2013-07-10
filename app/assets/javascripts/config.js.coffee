#= require ./smorodina

Smorodina.Config =
  urlTemplate: "http://{s}.tile.cloudmade.com/cda4cc8498bd4da19e72af2b606f5c6e/997/256/{z}/{x}/{y}.png"
  urlTemplateSat: 'http://otile{s}.mqcdn.com/tiles/1.0.0/sat/{z}/{x}/{y}.png'
  spinner:
    lines: 13            # The number of lines to draw
    length: 7            # The length of each line
    width: 4             # The line thickness
    radius: 10           # The radius of the inner circle
    corners: 1           # Corner roundness (0..1)
    rotate: 0            # The rotation offset
    color: '#000'        # #rgb or #rrggbb
    speed: 1             # Rounds per second
    trail: 60            # Afterglow percentage
    shadow: false        # Whether to render a shadow
    hwaccel: false       # Whether to use hardware acceleration
    className: 'spinner' # The CSS class to assign to the spinner
    zIndex: 2e9          # The z-index (defaults to 2000000000)
    top: 'auto'          # Top position relative to parent in px
    left: 'auto'         # Left position relative to parent in px
  redactor:
    path: "/assets/redactor-rails"
    css: "style.css"
    buttons: ['formatting', '|', 'bold', 'italic', 'deleted', '|', 'unorderedlist', 'orderedlist', 'outdent', 'indent']
    minHeight: 215

