namespace :fake do

  desc "Generates fake accounts for admins, 
        users authenticated by twitter, facebook and by the smorodina"
  
  #Creates fake users in database
  #This task should be run after all migrations passed
  #
  #Creadentials for user with twitter account: [test333@mailinator.com, 123456a]
  #Creadentials for user with facebook account: [test98732@yandex.ru, 123456ab]
  #Creadentials for user with both twitter and facebook account: Facebook: [test98732both@yandex.ru, 123456ab]
  #                                                              Twitter:  [test98732both@yandex.ru, 123456a ]

  task users: :environment do

    DEFAULT_PASSWORD = "12345678"
    
    #generic function for users creation 
    def user_creation
      u = User.new
      yield u
      u.confirm!
      u.save
    end

    def create_admin
      user_creation do |u|
        u.email = "admin@smorodina.com"
        u.password = DEFAULT_PASSWORD
        u.roles = [:admin]
      end
    end

    def create_smorodina_user
      user_creation do |u|
        u.email = "foo@bar.com"
        u.password = DEFAULT_PASSWORD
      end
    end
    
    def create_twitter_user
      user_creation do |u|
        u.password = Devise.friendly_token[0,20]
        u.authentications.build provider: "twitter", uid: "1374723392",
                                oauth_token: "1374723392-VuHlTNZ4fLbsuJTGa97s17zOrUmBGtQIlswcFPl",
                                oauth_token_secret: "UYbLraysvYb58BIfgczv6luS34GWYKJRBYSmjP9uZQ"
        u.skip_confirmation!
      end
    end
    
    def create_facebook_user
      user_creation do |u|
        u.authentications.build  email: "test98732@yandex.ru", provider: "facebook",
                                 uid: "1374723392", oauth_token: "BAADjvog0lOQBANY1VZCO4YNJ4tLmwjnoBg1mkOR0DZAziJzIGB..."
        u.skip_confirmation!
      end
    end

    def create_user_with_twitter_and_facebook
      user_creation do |u|
        u.authentications.build  email: "test98732both@yandex.ru", provider: "facebook",
                                 uid: "100005807075284", oauth_token: "BAADjvog0lOQBALli88ttEcBHPgNKiGJ8AAnA8TwRhd0BkF9MhS..."

        u.authentications.build provider: "twitter", uid: "1376596092", oauth_token: "1376596092-OwRhVrhvHZdbCOsK3oNQS7kOy9iXLWC0LkxRXA2",
                                oauth_token_secret: "x6GgIrVxhT3Dx63Fx6o0fQYGxfk0uiPEQ1j5"
        u.skip_confirmation!
      end
    end

    puts "creating users..."
    create_admin
    create_smorodina_user
    create_twitter_user
    create_facebook_user
    create_user_with_twitter_and_facebook
  end
end