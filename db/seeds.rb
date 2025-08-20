# db/seeds.rb
puts "Cleaning…"
Activity.destroy_all
Category.destroy_all
User.destroy_all

ActiveRecord::Base.transaction do
  puts "Creating admin user (Devise)…"
  admin = User.create!(
    email: "admin@paris.com",
    username: "admin",
    age: 35,
    phone_number: "0601020304",
    password: "azerty",
    password_confirmation: "azerty"
    # admin: true
  )

  puts "Creating 4 specific users (email=username@mail.fr, password=azerty)…"
  %w[aurel virg tiph fred].each_with_index do |uname, idx|
    User.create!(
      email: "#{uname}@mail.fr",
      username: uname,
      age: 25 + idx,                       # ajuste si besoin
      phone_number: "060000000#{idx + 1}", # ajuste si besoin
      password: "azerty",
      password_confirmation: "azerty"
    )
  end

  puts "Creating categories…"
  cats = {
    culture:    Category.create!(name: "🏰 Culture"),
    nature:     Category.create!(name: "🌿 Nature"),
    sport:      Category.create!(name: "🏋️ Sport"),
    relaxation: Category.create!(name: "🧘 Relaxation"),
    food:       Category.create!(name: "🍣 Food"),
    leisure:    Category.create!(name: "🎮 Leisure"),
    nightlife:  Category.create!(name: "🍻 Nightlife")
  }

  puts "Creating activities (English names & descriptions)…"
  activities = [
    {
      name: "Eiffel Tower",
      address: "Champ de Mars, 75007 Paris",
      description: "Built in 1889, this iron icon grants sweeping views over the Seine and Haussmann rooftops. Ride up to the second level for a stellar panorama, then unwind on the Champ de Mars at sunset.",
      category: :culture
    },
    {
      name: "Louvre Museum",
      address: "Rue de Rivoli, 75001 Paris",
      description: "Former royal palace turned the world’s largest art museum. From Egyptian antiquities to Italian masters—map your route to enjoy the essentials without rushing.",
      category: :culture
    },
    {
      name: "Notre-Dame Cathedral",
      address: "6 Parvis Notre-Dame, 75004 Paris",
      description: "Gothic masterpiece on the Île de la Cité, famed for its sculpted façade and rose windows. Stroll the riverbanks and square to admire the stonework and lively Seine.",
      category: :culture
    },
    {
      name: "Sacré-Cœur Basilica",
      address: "35 Rue du Chevalier de la Barre, 75018 Paris",
      description: "Snow-white basilica crowning Montmartre. Reach it on foot or via funicular; the 180° city view is breathtaking, with cobbled lanes, studios, and cafés all around.",
      category: :culture
    },
    {
      name: "Luxembourg Gardens",
      address: "75006 Paris",
      description: "Classic Parisian park with French-style parterres, green chairs under chestnut trees, and a pond with toy sailboats. Perfect spot for reading or a chic picnic.",
      category: :nature
    },
    {
      name: "Bois de Boulogne Park",
      address: "75016 Paris",
      description: "A vast green escape with lakes, rowboats, and long alleys. Ideal for a run or bike ride—pair it with a visit to the Fondation Louis Vuitton nearby.",
      category: :nature
    },
    {
      name: "Buttes-Chaumont Park",
      address: "1 Rue Botzaris, 75019 Paris",
      description: "Dramatic park with cliffs, a grotto, and the Temple of Sybil. Footbridges lead to scenic lookouts—golden hour here is especially striking.",
      category: :nature
    },
    {
      name: "Parc des Princes Stadium",
      address: "24 Rue du Commandant Guilbaud, 75016 Paris",
      description: "Mythic home of PSG with a crackling match-day atmosphere. Off-season tours reveal tunnels, pitchside views, and the stands.",
      category: :sport
    },
    {
      name: "Charléty Stadium",
      address: "99 Boulevard Kellermann, 75013 Paris",
      description: "Versatile venue hosting athletics and team sports. A southern Paris hub for major events and local competition alike.",
      category: :sport
    },
    {
      name: "Piscine Pontoise Art-Deco Pool",
      address: "19 Rue de Pontoise, 75005 Paris",
      description: "Glorious 1930s pool with famed late openings. Neat lane organization under an elegant glass roof—bring a cap and enjoy a central-Left-Bank swim.",
      category: :sport
    },
    {
      name: "Nuxe Spa Montorgueil",
      address: "32 Rue Montorgueil, 75001 Paris",
      description: "Stone-arched cabins, soft lights, and signature massages craft a deep reset—steps from a pedestrian street packed with gourmet spots.",
      category: :relaxation
    },
    {
      name: "Great Mosque Hammam",
      address: "39 Rue Geoffroy-Saint-Hilaire, 75005 Paris",
      description: "Steam rooms, black-soap scrub, and a bright rest area. After your ritual, sip mint tea and taste pastries in the Moorish garden café.",
      category: :relaxation
    },
    {
      name: "Aligre Market",
      address: "Place d’Aligre, 75012 Paris",
      description: "A lively blend of covered hall and open-air stalls from morning to noon. Cheesemongers, greengrocers, and wine shops—assemble a fresh, seasonal lunch.",
      category: :food
    },
    {
      name: "Rue des Rosiers",
      address: "75004 Paris",
      description: "The Marais’s culinary heart, famed for falafel stands and Jewish eateries. Between icons, discover small bakeries, delis, and local boutiques.",
      category: :food
    },
    {
      name: "The Food Market (Belleville)",
      address: "Boulevard de Belleville, 75020 Paris",
      description: "Open-air street-food rendezvous showcasing rotating vendors and global bites. Go early to skip lines and sample several menus.",
      category: :food
    },
    {
      name: "Centre Pompidou",
      address: "Place Georges-Pompidou, 75004 Paris",
      description: "High-tech architecture with outdoor escalators and superb views. A landmark collection of modern art, bold temporary shows, and a stellar bookstore.",
      category: :culture
    },
    {
      name: "Seine River Cruise",
      address: "Port de la Bourdonnais, 75007 Paris",
      description: "Commented cruise revealing bridges and monuments from a cinematic angle. Evening departures spotlight the city’s illuminations.",
      category: :leisure
    },
    {
      name: "Latin Quarter",
      address: "75005 Paris",
      description: "Universities, historic bookshops, and timeworn cafés in a maze of medieval lanes. Close to the Panthéon and Jardin des Plantes—always buzzing.",
      category: :leisure
    },
    {
      name: "Moulin Rouge",
      address: "82 Boulevard de Clichy, 75018 Paris",
      description: "Legendary cabaret of feathers and sequins—the home of the French cancan. Dinner-show available for a quintessentially Parisian night.",
      category: :nightlife
    },
    {
      name: "Rex Club",
      address: "5 Boulevard Poissonnière, 75002 Paris",
      description: "Temple of Paris’s electronic scene: focused sound system and curated line-ups. A must for techno/house lovers seeking a serious dance floor.",
      category: :nightlife
    }
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

  puts "✅ Seed OK — Users: #{User.count}, Categories: #{Category.count}, Activities: #{Activity.count}"
end
