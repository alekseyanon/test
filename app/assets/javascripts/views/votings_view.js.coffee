class Smorodina.Views.Votings extends Backbone.View
	el: '.pic_vote'

	events:
    'submit form' : 'prevent_submit'

  prevent_submit: (e, dt)->
    e.preventDefault()
    console.log('submiting data')
    data = $(e.currentTarget).serialize()
    url = $(e.currentTarget).attr 'action'
    $.post url + '.json', data, (dt)->
      console.log(dt)
    
    
	before_ajax_vote: (evt, xhr, settings)->
		@replace = $(evt.currentTarget).parents('.pic_vote').first()
		@replace.animate opacity: 0.25
	
	after_ajax_vote: (evt, data, status, xhr)->
		@replace.animate opacity: 1
		@replace.replaceWith data.responseText
		new Smorodina.Views.Votings
