# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Generates user's bio.
def generate_bio
  "#{Faker::Job.title}" \
  "\n@#{Faker::Company.name.delete(',').gsub(/(\s+)/, '_')}" \
  "\n#{Faker::Company.catch_phrase}" \
  "\n##{Faker::ProgrammingLanguage.name.gsub(/(\s+)/, '_')} ##{Faker::Job.key_skill.gsub(/(\s+)/, '_')} ##{Faker::Science.element.gsub(/(\s+)/, '_')}"
end

def generate_location
  "#{Faker::Address.country}"[0,29]
end

# Return a random user in the database.
def random_user
  count = User.count
  random_offset = rand(count)
  random_user = User.offset(random_offset).first
end

# Generates micropost's content.
def generate_content
  "#{Faker::Hacker.say_something_smart}" \
  "\n@#{random_user.username} @#{random_user.username}" \
  "\n@#{Faker::Ancient.hero.gsub(/(\s+)/, '_')} @#{Faker::Ancient.god.gsub(/(\s+)/, '_')}" \
  "\n##{Faker::Hacker.abbreviation} ##{Faker::Hacker.noun.gsub(/(\s+)/, '_')} ##{Faker::Hacker.verb.gsub(/(\s+)/, '_')}"
end

# Generates comment's content.
def generate_comment_content
  "#{Faker::Hacker.say_something_smart}"
end

# Creates a main sample user.
User.create!(
    name:                  'Admin',
    username:              'admin',
    email:                 'example@railstutorial.org',
    password:              'password',
    password_confirmation: 'password',
    admin:                 true,
    activated:             true,
    activated_at:          Time.zone.now,
    bio:                   generate_bio,
    location:              generate_location
)

demo_user = User.create!(
    name:                  'Demo User',
    username:              'DemoUser',
    email:                 'demo_user@example.com',
    password:              'password',
    password_confirmation: 'password',
    activated:             true,
    activated_at:          Time.zone.now,
    bio:                   generate_bio,
    location:              generate_location
)

# Generates a bunch of additional users with Faker.
98.times do |n|
  name     = Faker::FunnyName.unique.two_word_name
  email    = "example-#{n+1}@railstutorial.org"
  password = 'password'

  User.create(
    name:                  name,
    email:                 email,
    password:              password,
    password_confirmation: password,
    activated:             true,
    activated_at:          Time.zone.now,
    bio:                   generate_bio,
    location:              generate_location
  )
end

# Gererates microposts for a subset of users.
users = User.order(:created_at).take(50)

users.each do |user|
  content = generate_content
  user.microposts.create!(content: content)
end

# Gererates microposts for a subset of users.
users = User.order(:created_at).take(5)
49.times do
  users.each do |user|
    content = generate_content
    user.microposts.create!(content: content)
  end
end


users = User.order(:created_at).take(6)
users.each_with_index do |user, index|
  content = generate_content
  micropost = user.microposts.create!(content: content)
  micropost.image.attach(io: File.open("app/assets/images/#{12-index}.png"), filename: "#{12-index}.png", content_type: 'image/png')

  content = generate_content
  user.microposts.create!(content: content)
end
users.each_with_index do |user, index|
  content = generate_content
  micropost = user.microposts.create!(content: content)
  micropost.image.attach(io: File.open("app/assets/images/#{6-index}.png"), filename: "#{6-index}.png", content_type: 'image/png')

  content = generate_content
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

# Seed the comments.
threads = Commontator::Thread.all
threads.each_with_index do |thread, index|
  if index % 2 == 0
    # Comment level 1
    3.times do
      content = generate_comment_content
      comment_level_1 = thread.comments.create!(
        creator_type: "User",
        creator_id: random_user.id,
        body: content
      )

      # Comment level 2
      if comment_level_1.id % 3 == 0
        3.times do
          content = generate_comment_content
          comment_level_2 = thread.comments.create!(
            creator_type: "User",
            creator_id: random_user.id,
            body: content,
            parent_id: comment_level_1.id
          )

          # Comment level 3
          if comment_level_2.id % 4 == 0
            2.times do
              content = generate_comment_content
              comment_level_3 = thread.comments.create!(
                creator_type: "User",
                creator_id: random_user.id,
                body: content,
                parent_id: comment_level_2.id
              )
            end
          end
        end
      end
    end
  end
end

# Seeds the votes.
microposts = Micropost.all
microposts.each_with_index do |micropost, index|
  if index % 2 == 0
    rand(1..3).times do
      random_user.likes micropost
    end
  end
  if index % 3 == 0
    demo_user.likes micropost
  end
end

comments = Commontator::Comment.all
comments.each_with_index do |comment, index|
  if index % 3 == 0
    rand(1..3).times do
      random_user.likes comment
    end
  end
  if index % 4 == 0
    demo_user.likes comment
  end
end
