class Smorodina.Models.GeoObject extends Backbone.Model
  address: ->
    (@get('agc_titles')[id] for id in @get('agc')?.agus or []).join ', '