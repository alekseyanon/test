#= require routers/global_router

Smorodina.Pages.ObjectShow = (object_name)->
  $ ->
    new Smorodina.Views.ObjectShow object_id: object_name
