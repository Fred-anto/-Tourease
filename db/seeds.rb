# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# seeder categories

puts "destroy all categories"
Category.destroy_all

puts "Creation of categories"
Category.create!(name: '🏰 Culture')
Category.create!(name: '🌳 Nature')
Category.create!(name: '🏋️‍♂️ Sport')
Category.create!(name: '🧘 Relaxation')
Category.create!(name: '🍣 Food')
Category.create!(name: '🎮 Leisure')
Category.create!(name: '🥂 Nightlife')

puts "Categories created"
