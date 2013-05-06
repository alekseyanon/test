$(document).ready ->
	$('.pic_show__image__navi').css({opacity: 0});
	$('.pic_show__image').mouseenter ->
		$('.pic_show__image__navi').animate({opacity: 1});
	$('.pic_show__image').mouseleave ->
		$('.pic_show__image__navi').animate({opacity: 0});

  
