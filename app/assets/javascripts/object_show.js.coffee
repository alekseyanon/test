#= require routers/global_router

#TODO: rework reserved routed
Smorodina.Pages.ObjectShow = (object_name)->
  $ ->
    reserved = ['new', 'my_location', 'search', 'do_search', 'coordinates', 'nearest_node', 'count']
    if _.indexOf(reserved, object_name) == -1
      new Smorodina.Views.ObjectShow object_id: object_name
