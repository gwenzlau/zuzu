namespace :db do
  desc "Erase and fill database with sample data"
  task populate: :environment do

   [User].each(&:delete_all)

    5.times do |n|
      puts "[DEBUG] creating user #{n+1} of 10"
      name = Faker::Name.name
      email = "user-#{n+1}@example.com"
      password = "password"
      User.create!( signature: name,
                    email: email,
                    password: password,
                    password_confirmation: password)
    end

    User.all.each do |user|
      puts "[DEBUG] uploading images for user #{user.id} of #{User.last.id}"
      3.times do |n|
        description = %w(cool awesome crazy wow adorbs incredible).sample
        user.posts.create!(content: description)
      end
    end
  end
end