module AuthenticationsHelper
	def provider_class(provider)
    "vkontakte" == provider ? "vk" : provider
  end
end
