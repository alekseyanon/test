namespace :fake do

  desc "Generates fake accounts for admins, 
        users authenticated by twitter, facebook and by the smorodina"
  
  task users: :environment do

    puts "creating users..."

    a = User.new email: "admin@smorodina.com", password: "12345678"
    a.confirm!
    a.roles = [:admin]
    a.save

    u = User.new email: "foo@bar.com", password: "12345678"
    u.confirm!
    u.save

    u_twitter = User.new(password: Devise.friendly_token[0,20])
    u_twitter.tap do |u|
      u.authentications.build provider: "twitter", uid: "1374723392"
      u.skip_confirmation!
      u.save!
      u.confirm!
    end

    u_facebook = User.new(password: Devise.friendly_token[0,20])
    u_facebook.tap do |u|
      u.authentications.build  email: "test98732@yandex.ru", provider: "facebook",
                                        uid: "1374723392", oauth_token: "BAADjvog0lOQBANY1VZCO4YNJ4tLmwjnoBg1mkOR0DZAziJzIGB..."
      u.skip_confirmation!
      u.save!
      u.confirm!
    end

    u_t_and_f = User.new(password: Devise.friendly_token[0,20])
    u_t_and_f.tap do |u|
      u.authentications.build  email: "test98732@yandex.ru", provider: "facebook",
                                        uid: "3374723392", oauth_token: "BAADjvog0lOQBANY1VZCO4YNJ4tLmwjnoBg1mkOR0DZAziJzIGB..."
      u.authentications.build provider: "twitter", uid: "3374723392"
      u.skip_confirmation!
      u.save!
      u.confirm!
    end

    #Twitter fake credentials for OAuth:
    #test333@mailinator.com
    #123456a
    
    #Facebook fake credentials
    #test98732@yandex.ru
    #123456ab
  end
end