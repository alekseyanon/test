class Smorodina.Views.ImageShow extends Backbone.View
	el: '#pic_show_content'

	events:
		'mouseenter .pic_show__image'											: 'show_navi'
		'mouseleave .pic_show__image'											: 'hide_navi'
		'ajax:beforeSend .pic_show__image__navi__left a'  : 'before_ajax'
		'ajax:beforeSend .pic_show__image__navi__right a' : 'before_ajax'
		'ajax:complete .pic_show__image__navi__left a'	  : 'after_ajax'
		'ajax:complete .pic_show__image__navi__right a'	  : 'after_ajax'
		'click .pic__author__actions_respond a'	  				: 'simple_add_comment'


	initialize: ->
		this.$el.find('.pic_show__image__navi').css({opacity: 0})
		spinner_config = Smorodina.Config.spinner
		@spinner = new Spinner spinner_config
		@init_ya_share()
				
	show_navi: ->
		this.$el.find('.pic_show__image__navi').animate({opacity: 1})

	hide_navi: ->
		this.$el.find('.pic_show__image__navi').animate({opacity: 0})

	before_ajax: (e)->
		window.location.hash = e.currentTarget.hash
		@spinner.spin($('.pic_show__spinner__home').get 0)
		$('#pic_show_content').animate({opacity: 0.25})
	
	after_ajax: (evt, data, status, xhr)->
		$('#pic_show_content').html(data.responseText);
		$('#pic_show_content').animate({opacity: 1})
		@spinner.stop()
		@init_ya_share()
		new Smorodina.Views.Comments
		new Smorodina.Views.Votings

	init_ya_share: ->
		new Ya.share(
			'element': 'ya_share__block',
			'elementStyle':{
				'quickServices': ['yaru', 'vkontakte', 'facebook', 'twitter', 'odnoklassniki', 'moimir'],
				'type': 'icon'
			}
		);
	
	simple_add_comment: (e)->
		$('.pic_comments__add input[type="text"]').focus();
		e.preventDefault()


