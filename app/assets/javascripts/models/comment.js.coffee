class Smorodina.Models.Comment extends Backbone.Model

  initialize: ->
    @set comments: new Smorodina.Collections.Comments @get('comments')
