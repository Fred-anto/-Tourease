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
puts "Cleaning…"
Activity.destroy_all
Category.destroy_all
User.destroy_all
ActiveRecord::Base.transaction do
  puts "Creating admin user (Devise)…"
  admin = User.create!(
    email: "admin@paris.com",
    username: "AdminParis",
    age: 35,
    phone_number: "0601020304",
    password: "password",
    password_confirmation: "password"
    # admin: true # décommente si tu as la colonne admin:boolean
  )
  puts "Creating categories…"
  cats = {
    culture:    Category.create!(name: ":european_castle: Culture"),
    nature:     Category.create!(name: ":herb: Nature"),
    sport:      Category.create!(name: ":weight_lifter: Sport"),
    relaxation: Category.create!(name: ":person_in_lotus_position: Relaxation"),
    food:       Category.create!(name: ":sushi: Food"),
    leisure:    Category.create!(name: ":video_game: Leisure"),
    nightlife:  Category.create!(name: ":beers: Nightlife")
  }
  puts "Creating activities…"
  activities = [
    { name: "Tour Eiffel",             address: "Champ de Mars, 75007 Paris",             description: "Symbole de Paris.",                          category: :culture },
    { name: "Musée du Louvre",         address: "Rue de Rivoli, 75001 Paris",              description: "Musée d'art majeur.",                       category: :culture },
    { name: "Cathédrale Notre-Dame",   address: "6 Parvis Notre-Dame, 75004 Paris",        description: "Chef-d’œuvre gothique.",                    category: :culture },
    { name: "Sacré-Cœur",              address: "35 Rue du Chevalier de la Barre, 75018",  description: "Vue sur tout Paris.",                       category: :culture },
    { name: "Jardin du Luxembourg",    address: "75006 Paris",                              description: "Promenade et détente.",                     category: :nature },
    { name: "Bois de Boulogne",        address: "75016 Paris",                              description: "Grand espace vert.",                        category: :nature },
    { name: "Parc des Buttes-Chaumont",address: "1 Rue Botzaris, 75019 Paris",              description: "Relief et belvédères.",                     category: :nature },
    { name: "Parc des Princes",        address: "24 Rue du Cmdt Guilbaud, 75016",           description: "Stade du PSG.",                             category: :sport },
    { name: "Stade Charléty",          address: "99 Bd Kellermann, 75013",                  description: "Athlé & events.",                           category: :sport },
    { name: "Piscine Pontoise",        address: "19 Rue de Pontoise, 75005",                description: "Piscine art déco nocturne.",                category: :sport },
    { name: "Spa Nuxe Montorgueil",    address: "32 Rue Montorgueil, 75001",                description: "Parenthèse bien-être.",                     category: :relaxation },
    { name: "Hammam de la Grande Mosquée", address: "39 Rue Geoffroy-Saint-Hilaire, 75005", description: "Hammam traditionnel.",                      category: :relaxation },
    { name: "Marché d’Aligre",         address: "Place d’Aligre, 75012",                    description: "Marché vivant & halles.",                   category: :food },
    { name: "Rue des Rosiers",         address: "75004 Paris",                              description: "Falafels & spécialités juives.",             category: :food },
    { name: "Le Food Market",          address: "Boulevard de Belleville, 75020",           description: "Street-food à ciel ouvert (dates).",        category: :food },
    { name: "Centre Pompidou",         address: "Place G.-Pompidou, 75004",                 description: "Art moderne & contemporain.",                category: :culture },
    { name: "Balade en bateau sur la Seine", address: "Port de la Bourdonnais, 75007",     description: "Croisière parisienne.",                      category: :leisure },
    { name: "Quartier Latin",          address: "75005 Paris",                              description: "Librairies, cafés, animation.",              category: :leisure },
    { name: "Moulin Rouge",            address: "82 Bd de Clichy, 75018",                   description: "Cabaret mythique.",                          category: :nightlife },
    { name: "Rex Club",                address: "5 Bd Poissonnière, 75002",                 description: "Club électro emblématique.",                 category: :nightlife }
  ]
  activities.each do |attrs|
    Activity.create!(
      name:        attrs[:name],
      description: attrs[:description],
      address:     attrs[:address],
      category:    cats.fetch(attrs[:category]),
      user:        admin
    )
  end
  puts ":white_check_mark: Seed OK — Users: #{User.count}, Categories: #{Category.count}, Activities: #{Activity.count}"
end
