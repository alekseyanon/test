#= require routers/global_router
#= require collections/categories

Smorodina.Pages.ImageShow = ->
	$ ->
		new Smorodina.Views.ImageShow
		new Smorodina.Views.Comments
