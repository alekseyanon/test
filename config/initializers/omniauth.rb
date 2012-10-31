Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, '13miB5TnS4NNXTXn94DA', 'zXmLg9CIivjOV6prxEGEuKGD29g7NpoK6aXM21ZQY'
  provider :facebook, '107070769454922', '438f784a07c9772aaad60042c5bce988'
  #provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end