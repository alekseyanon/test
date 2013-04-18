#= require ../smorodina

class Smorodina.Routers.Global extends Backbone.Router
  routes:
    'events':                       Smorodina.Pages.Events
    'events/search':                Smorodina.Pages.Events
    'geo_objects/search':           Smorodina.Pages.GeoObjects
    '':                             Smorodina.Pages.Index
