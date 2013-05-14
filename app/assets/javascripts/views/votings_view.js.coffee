class Smorodina.Views.Votings extends Backbone.View
	el: '.pic_vote'

	events:
		'ajax:beforeSend form'  	: 'before_ajax_vote'
		'ajax:complete form'			: 'after_ajax_vote'

	before_ajax_vote: (evt, xhr, settings)->
		@replace = $(evt.currentTarget).parents('.pic_vote').first()
		@replace.animate opacity: 0.25
	
	after_ajax_vote: (evt, data, status, xhr)->
		@replace.animate opacity: 1
		@replace.replaceWith data.responseText
		new Smorodina.Views.Votings
