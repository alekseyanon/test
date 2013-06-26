namespace :fake do

  desc "Generates fake accounts for admins,
        users authenticated by twitter, facebook and by the smorodina"

  task prepare_images_seed: :environment do

    IMAGES_DIR = Rails.root.join('spec', 'fixtures', 'images', 'tmp_imgs')

    def seed_images
      if Dir["#{IMAGES_DIR}/*"].empty?
        15.times{|i| `curl http://lorempixel.com/300/300/ -o #{IMAGES_DIR}/#{i}.jpg`}
      end
    end

    def pick_random_image
      img = Dir.entries(IMAGES_DIR).reject!{|file| ['.', '..', '.gitignore'].include? file}.sample
      IMAGES_DIR.join(img).to_s
    end
  end
end
