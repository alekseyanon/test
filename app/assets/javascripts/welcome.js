(function(){

	var apiKey = 'cda4cc8498bd4da19e72af2b606f5c6e',
		tileUrlTemplate = "http://{s}.tile.cloudmade.com/cda4cc8498bd4da19e72af2b606f5c6e/997/256/{z}/{x}/{y}.png";

	$(function(){

		// create a map in the "map" div, set the view to a given place and zoom
		var map = L.map('map').setView([51.505, -0.09], 13);

		// add an OpenStreetMap tile layer
		L.tileLayer(tileUrlTemplate, {
			attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
		}).addTo(map);

		// add a marker in the given location, attach some popup content to it and open the popup
		L.marker([51.5, -0.09]).addTo(map)
			.bindPopup('A pretty CSS3 popup. <br> Easily customizable.')
			.openPopup();


		var $searchInput = $('#mainSearchFieldInput');
		$searchInput.on('focus', function(){
			$('.how-to-search').addClass('how-to-search_hidden');
		})

	});



}());

