# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.delete_all

User.create name: "Hoàng Hải",
  email: "hai.hp.96@gmail.com",
  password: "123456",
  role: 1

100.times do |index|
  User.create name: FFaker::NameVN.name,
    email: "example-#{index+1}@railstutorial.org",
    address: FFaker::AddressUK.street_address,
    birthday: FFaker::Time.between(10.years.ago, Time.now),
    phone: FFaker::PhoneNumberAU.phone_prefix,
    gender: Random.rand(0..2),
    password: "123456",
    role: 0
end
