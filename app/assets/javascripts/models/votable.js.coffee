class Smorodina.Models.Votable extends Backbone.Model

  initialize: ->
    @on 'sync', @parse_response 

  parse_response: (model, response)->
    @set 'current_user_vote': response.user_vote, 'votes_for': response.positive, 'votes_against': response.negative

  create_vote: (sign)->
    @set sign: sign, id: null
    @save()

  destroy_vote: (sign)->
    @set sign: sign, id: '500'
    @destroy()
