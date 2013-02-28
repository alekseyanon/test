(function(){

	if(document.location.pathname === '/'){

		$(function(){

			var $searchInput = $('#mainSearchFieldInput');
			$searchInput.on('focus', function(){
				$('.how-to-search').addClass('how-to-search_hidden');
			});

			$('.control-panel__info-button')
				.on('click', function(){

				})
				.popover({
					html: true,
					placement: 'bottom',
					trigger: 'click',
					content: function(){
						return $('.control-panel__info-section').html();
					}
				});
			});

	}

}());

