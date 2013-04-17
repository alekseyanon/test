#= require ../smorodina

class Smorodina.Routers.Global extends Backbone.Router
  routes:
    'events':                       Smorodina.Pages.Events
    'events/search':                Smorodina.Pages.Events
    'landmark_descriptions/search': Smorodina.Pages.LandmarkDescriptions
    '':                             Smorodina.Pages.Index
