# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


User.create(
    email: "hai.hp.96@gmail.com",
    name: "Administrator",
    password: "123456",
    role: 1,
    activated: true)

User.create(
    email: "hai.hp.961@gmail.com",
    name: "Basic User",
    password: "123456",
    role: 0,
    activated: true)

10.times do |n|
  User.create(
      email: "example-#{n+1}@railstutorial.org",
      name: FFaker::Internet.user_name,
      password: FFaker::Internet.password,
      role: 0
  )
end

1000.times do
  Micropost.create(
      context: FFaker::LoremJA.words,
      user_id: Random.rand(1..12)
  )
end

1000.times do
  Relationship.create(
      follower_id: Random.rand(1..12),
      followed_id: Random.rand(1..12)
  )
end