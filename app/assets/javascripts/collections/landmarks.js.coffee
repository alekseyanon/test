#= require ../models/landmark
class Smorodina.Collections.Landmarks extends Backbone.Collection
  model: Smorodina.Models.Landmark
  url: '/landmark_descriptions.json'
