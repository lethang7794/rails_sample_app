# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creates a main sample user.
User.create!(
    name:                  'Admin',
    username:              'admin',
    email:                 'example@railstutorial.org',
    password:              'password',
    password_confirmation: 'password',
    admin:                 true,
    activated:             true,
    activated_at:          Time.zone.now
)

User.create!(
    name:                  'Sample App',
    username:              'SampleApp',
    email:                 'hi@sampleapp.com',
    password:              'password',
    password_confirmation: 'password',
    activated:             true,
    activated_at:          Time.zone.now
)

# Generates a bunch of additional users with Faker.
98.times do |n|
  name     = Faker::Name.unique.name
  email    = "example-#{n+1}@railstutorial.org"
  password = 'password'

  User.create(
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
    activated:             true,
    activated_at:          Time.zone.now
  )
end

# Gererates microposts for a subset of users.
users = User.order(:created_at).take(50)

users.each do |user|
  content = Faker::Lorem.sentence(word_count: 5)
  user.microposts.create!(content: content)
end

# Gererates microposts for a subset of users.
users = User.order(:created_at).take(5)
49.times do
  users.each do |user|
    content = Faker::Lorem.sentence(word_count: 5)
    user.microposts.create!(content: content)
  end
end


users = User.order(:created_at).take(6)
users.each_with_index do |user, index|
  content = Faker::Lorem.sentence(word_count: 5)
  micropost = user.microposts.create!(content: content)
  micropost.image.attach(io: File.open("app/assets/images/#{12-index}.png"), filename: "#{12-index}.png", content_type: 'image/png')

  content = Faker::Lorem.sentence(word_count: 5)
  user.microposts.create!(content: content)
end
users.each_with_index do |user, index|
  content = Faker::Lorem.sentence(word_count: 5)
  micropost = user.microposts.create!(content: content)
  micropost.image.attach(io: File.open("app/assets/images/#{6-index}.png"), filename: "#{6-index}.png", content_type: 'image/png')

  content = Faker::Lorem.sentence(word_count: 5)
  user.microposts.create!(content: content)
end

# Seed the relatioships.
user1 = User.first
user2 = User.second
users = User.all

following = users[1..49]
following.each { |followed| user1.follow(followed) }

followers = users[2..39]
followers.each { |follower| follower.follow(user1) }

following = users[2..49]
following.each { |followed| user2.follow(followed) }

followers = users[3..39]
followers.each { |follower| follower.follow(user2) }
