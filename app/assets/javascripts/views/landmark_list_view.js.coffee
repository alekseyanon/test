#= require ../collections/landmarks
class Smorodina.Views.LandmarkList extends Backbone.View
  collection: Smorodina.Collections.Landmarks
  initialize: ->
    @collection.on 'remove', (l)=>
      $("##{l.get('id')}").remove()
    @collection.on 'add', @addOne
  render: ->
    @collection.forEach @addOne
    this
  addOne: (l)=>
    @$el.append new Smorodina.Views.Landmark(model:l).render()
