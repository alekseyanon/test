namespace :fake do

  desc "Generates fake accounts for admins, 
        users authenticated by twitter, facebook and by the smorodina"
  
  task users: :environment do

    puts "creating users..."
    
    #Admin account
    a = User.new email: "admin@smorodina.com", password: "12345678"
    a.confirm!
    a.roles = [:admin]
    a.save
    
    #USER 0 registered through website
    u = User.new email: "foo@bar.com", password: "12345678"
    u.confirm!
    u.save
    
    #USER 1 has facebook account
    u_twitter = User.new(password: Devise.friendly_token[0,20])
    u_twitter.tap do |u|
      u.authentications.build provider: "twitter", uid: "1374723392",
                              oauth_token: "1374723392-VuHlTNZ4fLbsuJTGa97s17zOrUmBGtQIlswcFPl",
                              oauth_token_secret: "UYbLraysvYb58BIfgczv6luS34GWYKJRBYSmjP9uZQ"
      u.skip_confirmation!
      u.save!
      u.confirm!
    end
    
    #USER 2 has facebook account
    u_facebook = User.new(password: Devise.friendly_token[0,20])
    u_facebook.tap do |u|
      u.authentications.build  email: "test98732@yandex.ru", provider: "facebook",
                               uid: "1374723392", oauth_token: "BAADjvog0lOQBANY1VZCO4YNJ4tLmwjnoBg1mkOR0DZAziJzIGB..."
      u.skip_confirmation!
      u.save!
      u.confirm!
    end
    
    #USER 3 has both Twitter and Facebook accounts
    u_t_and_f = User.new(password: Devise.friendly_token[0,20])
    u_t_and_f.tap do |u|
      u.authentications.build  email: "test98732both@yandex.ru", provider: "facebook",
                               uid: "100005807075284", oauth_token: "BAADjvog0lOQBALli88ttEcBHPgNKiGJ8AAnA8TwRhd0BkF9MhS..."

      u.authentications.build provider: "twitter", uid: "1376596092", oauth_token: "1376596092-OwRhVrhvHZdbCOsK3oNQS7kOy9iXLWC0LkxRXA2",
                              oauth_token_secret: "x6GgIrVxhT3Dx63Fx6o0fQYGxfk0uiPEQ1j5"
      u.skip_confirmation!
      u.save!
      u.confirm!
    end
    
    #USER 1:
    #Twitter fake credentials
    #test333@mailinator.com
    #123456a
    
    #USER 2:
    #Facebook fake credentials
    #test98732@yandex.ru
    #123456ab
    
    #USER 3:
    #Twitter
    #test98732both@yandex.ru
    #123456a

    #Facebook
    #test98732both@yandex.ru
    #123456ab
  end
end
