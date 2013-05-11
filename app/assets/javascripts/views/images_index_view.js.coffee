class Smorodina.Views.ImagesIndex extends Backbone.View
	el: '.all-photos-page'

	events:
		'click .obj-page-gallery a'  : 'prevent_link'
		'contentLoaded #pic_show_content' : "content_loaded"

	initialize: ->
		spinner_config = Smorodina.Config.spinner
		@spinner = new Spinner spinner_config
		@show_modal(window.location.hash)
		
	prevent_link: (e)->
		window.location.hash = e.currentTarget.hash
		@show_modal(e.currentTarget.hash)
		return false;

	show_modal: (hash)->
		url = hash.replace('#', '');
		if(url.length > 0)
			$('#showImageModal').attr('data-url', url);
			$('#showImageModal').modal();
			$('#showImageModal #pic_show_content').html("");
			@spinner.spin($('#showImageModal .pic_show__spinner__home').get 0)
			$('#showImageModal #pic_show_content').load(url + '.js', ()->
				$('#pic_show_content').trigger('contentLoaded')
			);

	content_loaded: ->
		@spinner.stop()
		new Smorodina.Views.ImageShow
		new Smorodina.Views.Comments
		new Smorodina.Views.Votings
