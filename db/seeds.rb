# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

%w(andy xiaobei jon kitty hello messi kaka).each do |username|
  unless User.exists?(username: username)
    User.create(username: username, password: 12345678)
  end
end