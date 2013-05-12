class Smorodina.Views.Comments extends Backbone.View
	el: '.pic_comments'

	events:
		'ajax:beforeSend .pic_comments__comment__info__actions__respond a'  	: 'before_link_ajax'
		'ajax:complete .pic_comments__comment__info__actions__respond a'			: 'after_link_ajax'
		'click .pic_comments__add.hidable input[type="reset"]'								: 'reset_add_form'
		'ajax:beforeSend .pic_comments__add form'															: 'before_form_ajax'
		'ajax:complete .pic_comments__add form'																: 'after_form_ajax'
		'ajax:beforeSend .pic_comments__add.hidable form'											: 'before_h_form_ajax'
		'ajax:complete .pic_comments__add.hidable form'												: 'after_h_form_ajax'

	initialize: ->
				
	before_link_ajax: (evt, xhr, settings)->
		@append_to = $(evt.currentTarget).parents('.pic_comments__comment').first().find('.pic_comments__chid_comments').first()
	
	after_link_ajax: (evt, data, status, xhr)->
		@append_to.find('.pic_comments__add').remove();
		@append_to.append(data.responseText);

	reset_add_form: (event)->
		$(event.currentTarget).parents('.pic_comments__add').first().remove();

	before_h_form_ajax: (evt, xhr, settings)->
		$(evt.currentTarget).find("input[type='submit']").attr('disabled', 'disabled');
		@replace_to = $(evt.currentTarget)
		
	after_h_form_ajax: (evt, data, status, xhr)->
		@replace_to.parent().replaceWith(data.responseText);
		new Smorodina.Views.Votings
	
	before_form_ajax: (evt, xhr, settings)->
		@form = $(evt.currentTarget) 
		@form.find("input[type='submit']").attr('disabled', 'disabled');
		@form.find("input[type='text']").val('');

		
	after_form_ajax: (evt, data, status, xhr)->
		$('.pic_comments__list').append(data.responseText);
		@form.find("input[type='submit']").removeAttr('disabled');
		new Smorodina.Views.Votings

