# db/seeds.rb
require "open-uri"

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
    # --- Culture ---
    { name: "Musée d'Orsay", address: "1 Rue de la Légion d'Honneur, 75007 Paris", description: "Housed in a Beaux-Arts railway station, featuring Impressionist and Post-Impressionist masterpieces. Ideal for a half-day immersion in French art.", category: :culture },
    { name: "Panthéon", address: "Place du Panthéon, 75005 Paris", description: "Neoclassical monument where France honors its great citizens. Explore the crypts and gaze at the stunning dome from inside.", category: :culture },
    { name: "Opéra Garnier", address: "8 Rue Scribe, 75009 Paris", description: "A masterpiece of 19th-century architecture with lavish interiors and grand staircases. Guided tours reveal history and hidden corners.", category: :culture },
    { name: "Musée Rodin", address: "79 Rue de Varenne, 75007 Paris", description: "A serene museum dedicated to Rodin, with sculptures displayed in elegant gardens. Don’t miss 'The Thinker' and 'The Gates of Hell.'", category: :culture },
    { name: "Musée Picasso", address: "5 Rue de Thorigny, 75003 Paris", description: "A comprehensive collection of Picasso’s works, in a beautiful hôtel particulier in the Marais.", category: :culture },
    { name: "Sainte-Chapelle", address: "8 Boulevard du Palais, 75001 Paris", description: "Medieval chapel with extraordinary stained glass windows, illuminating stories from the Bible in vivid colors.", category: :culture },
    { name: "Palais de Tokyo", address: "13 Avenue du Président Wilson, 75116 Paris", description: "Cutting-edge contemporary art museum, often experimental and interactive, for modern art enthusiasts.", category: :culture },
    { name: "Petit Palais", address: "Avenue Winston Churchill, 75008 Paris", description: "Art museum with fine collections from antiquity to early 20th century, set in a grand Beaux-Arts building.", category: :culture },
    { name: "Maison de Victor Hugo", address: "6 Place des Vosges, 75004 Paris", description: "Historic home of the famous writer, offering insight into his life and works. Located in the picturesque Place des Vosges.", category: :culture },
    { name: "Musée de l'Orangerie", address: "Jardin Tuileries, 75001 Paris", description: "Home to Monet’s Water Lilies series and other impressionist works. Calm and luminous space perfect for art lovers.", category: :culture },

    # --- Nature ---
    { name: "Jardin des Tuileries", address: "Place de la Concorde, 75001 Paris", description: "Formal French garden connecting Louvre to Place de la Concorde, ideal for a stroll or relaxing by fountains.", category: :nature },
    { name: "Parc Monceau", address: "35 Boulevard de Courcelles, 75008 Paris", description: "Charming park with winding paths, statues, and romantic bridges, loved by locals for jogging and picnics.", category: :nature },
    { name: "Parc de la Villette", address: "211 Avenue Jean Jaurès, 75019 Paris", description: "Modern park with themed gardens, playgrounds, and cultural venues. Great for walking and family-friendly activities.", category: :nature },
    { name: "Parc André Citroën", address: "2 Rue Cauchy, 75015 Paris", description: "Contemporary park with geometric flower beds, greenhouses, and a tethered hot air balloon ride.", category: :nature },
    { name: "Île aux Cygnes", address: "75015 Paris", description: "Narrow artificial island on the Seine, with a walkable promenade and a mini Statue of Liberty at the end.", category: :nature },
    { name: "Bois de Vincennes", address: "75012 Paris", description: "Expansive park with lakes, a botanical garden, and walking trails. Rent a boat or visit the Parc Zoologique.", category: :nature },
    { name: "Jardin des Plantes", address: "57 Rue Cuvier, 75005 Paris", description: "Botanical garden featuring greenhouses, themed gardens, and the Natural History Museum.", category: :nature },
    { name: "Parc Floral de Paris", address: "Route de la Pyramide, 75012 Paris", description: "Flower park with seasonal blooms, concerts, and walking paths perfect for a relaxing afternoon.", category: :nature },
    { name: "Square du Vert-Galant", address: "Pont Neuf, 75001 Paris", description: "Tiny riverside park at the tip of Île de la Cité, peaceful and scenic for picnics or a quiet pause.", category: :nature },
    { name: "Promenade Plantée", address: "75012 Paris", description: "Elevated green walkway built on old railway tracks, inspiring the NYC High Line. Ideal for strolling or jogging.", category: :nature },

    # --- Sport ---
    { name: "Stade de France", address: "ZAC Paris Nord 2, 93216 Saint-Denis", description: "Iconic stadium hosting football, rugby, and concerts. Guided tours allow behind-the-scenes access.", category: :sport },
    { name: "Accor Arena", address: "8 Boulevard de Bercy, 75012 Paris", description: "Indoor venue for sports events and concerts. Experience thrilling matches from VIP to general seating.", category: :sport },
    { name: "Roland Garros", address: "2 Avenue Gordon Bennett, 75016 Paris", description: "Legendary tennis stadium, home to the French Open. Off-season tours highlight the courts and museum.", category: :sport },
    { name: "Paris Jean-Bouin Stadium", address: "1 Rue Nicole-Reine Lepaute, 75016 Paris", description: "Multi-purpose stadium mainly for rugby and football, offering an electric atmosphere during matches.", category: :sport },
    { name: "Piscine Molitor", address: "13 Rue Nungesser et Coli, 75016 Paris", description: "Art Deco swimming pool complex with outdoor and indoor pools, iconic for its history and architecture.", category: :sport },
    { name: "Velodrome de Vincennes", address: "75012 Paris", description: "Historic cycling track hosting competitions and training sessions. Offers rental and event opportunities.", category: :sport },
    { name: "La Coulée Verte Cyclable", address: "75012 Paris", description: "Scenic cycling path connecting multiple parks and gardens, perfect for active exploration.", category: :sport },
    { name: "Golf de Paris Longchamp", address: "1 Route des Tribunes, 75016 Paris", description: "Challenging 9-hole golf course in a serene Parisian setting.", category: :sport },
    { name: "Parc de Choisy Sports Complex", address: "10 Rue des Frères d'Astier de la Vigerie, 75013 Paris", description: "Facilities for tennis, basketball, and indoor sports; a community hub for athletes.", category: :sport },
    { name: "Skatepark du Quai de la Gare", address: "75013 Paris", description: "Urban skatepark along the Seine for skateboarders and rollerbladers of all levels.", category: :sport },

    # --- Relaxation ---
    { name: "Spa NUXE Montorgueil", address: "32 Rue Montorgueil, 75001 Paris", description: "Stone-arched cabins, soft lights, and signature massages craft a deep reset.", category: :relaxation },
    { name: "Hammam Pacha", address: "8 Rue Saint-Denis, 75001 Paris", description: "Traditional Turkish bath with steam rooms, massages, and a calm atmosphere.", category: :relaxation },
    { name: "Institut Dior Spa", address: "28 Avenue Montaigne, 75008 Paris", description: "Luxury spa offering skincare rituals, massages, and a serene ambiance in Paris’ fashion district.", category: :relaxation },
    { name: "Calicéo Spa", address: "2 Rue du Général Leclerc, 78150 Le Chesnay", description: "Large spa complex with pools, jacuzzis, and relaxation areas, perfect for a full-day reset.", category: :relaxation },
    { name: "Deep Nature Spa", address: "13 Rue du Faubourg Saint-Honoré, 75008 Paris", description: "Cozy, elegant spa offering facials, massages, and aromatic treatments.", category: :relaxation },
    { name: "Spa My Blend by Clarins", address: "16 Avenue Montaigne, 75008 Paris", description: "Bespoke luxury treatments in a peaceful, intimate setting.", category: :relaxation },
    { name: "Les Cent Ciels Spa", address: "45 Rue de Lyon, 75012 Paris", description: "Thermal hammam and massage treatments with calm surroundings for complete relaxation.", category: :relaxation },
    { name: "Cinq Mondes Spa", address: "17 Rue de Castiglione, 75001 Paris", description: "Exotic massage and beauty rituals inspired by global traditions.", category: :relaxation },
    { name: "Spa L’Occitane", address: "30 Avenue des Champs-Élysées, 75008 Paris", description: "French-inspired wellness treatments in a chic, tranquil environment.", category: :relaxation },
    { name: "Hôtel Molitor Spa", address: "13 Rue Nungesser et Coli, 75016 Paris", description: "Art Deco swimming pool with spa treatments, combining relaxation and iconic architecture.", category: :relaxation },

    # --- Food ---
    { name: "Marché des Enfants Rouges", address: "39 Rue de Bretagne, 75003 Paris", description: "Paris’ oldest covered market offering diverse international food stalls and fresh products.", category: :food },
    { name: "Rue Montorgueil", address: "75001 Paris", description: "Lively pedestrian street with bakeries, cafés, fromageries, and restaurants.", category: :food },
    { name: "La Rue Cler", address: "Rue Cler, 75007 Paris", description: "Charming market street near the Eiffel Tower, ideal for sampling French specialties.", category: :food },
    { name: "Marché Bastille", address: "Boulevard Richard-Lenoir, 75011 Paris", description: "Open-air market with fresh produce, cheeses, meats, and street food.", category: :food },
    { name: "Marché Saint-Quentin", address: "85 bis Boulevard de Magenta, 75010 Paris", description: "Covered market with fresh ingredients and local delicacies.", category: :food },
    { name: "Rue Mouffetard Food Street", address: "75005 Paris", description: "Historic street with lively food vendors, bakeries, and cafés.", category: :food },
    { name: "Marché d’Aligre", address: "Place d’Aligre, 75012 Paris", description: "Colorful market with fresh produce, flowers, and vintage finds.", category: :food },
    { name: "Rue de la Huchette", address: "75005 Paris", description: "Famous for small bistros and traditional French food tucked into narrow streets.", category: :food },
    { name: "La Grande Épicerie", address: "38 Rue de Sèvres, 75007 Paris", description: "Upscale food hall offering gourmet products from all over France.", category: :food },
    { name: "Marché des Batignolles", address: "Place du Dr Félix Lobligeois, 75017 Paris", description: "Organic-focused market with fresh vegetables, meats, and cheeses.", category: :food },

    # --- Leisure ---
    { name: "Seine River Cruise", address: "Port de la Bourdonnais, 75007 Paris", description: "Commented cruise revealing bridges and monuments from a cinematic angle.", category: :leisure },
    { name: "Montmartre Walking Tour", address: "75018 Paris", description: "Guided exploration of Montmartre’s winding streets, artists’ squares, and iconic cafés.", category: :leisure },
    { name: "Batobus (Seine Hop-On Hop-Off Boat)", address: "75001 Paris", description: "Flexible boat service along the Seine, perfect for sightseeing at your own pace.", category: :leisure },
    { name: "Paris Open-Air Cinema", address: "Parc de la Villette, 75019 Paris", description: "Summer event showcasing films under the stars in a relaxed outdoor setting.", category: :leisure },
    { name: "Picasso Sculpture Garden", address: "Musée Picasso, 75003 Paris", description: "Outdoor exhibition of sculptures in a serene courtyard.", category: :leisure },
    { name: "Latin Quarter Stroll", address: "75005 Paris", description: "Historic district with cafés, bookstores, and lively streets to wander at leisure.", category: :leisure },
    { name: "Île Saint-Louis Exploration", address: "75004 Paris", description: "Charming island perfect for a stroll and tasting Berthillon ice cream.", category: :leisure },
    { name: "Canal Saint-Martin Walk", address: "75010 Paris", description: "Picturesque canal with footbridges, trendy cafés, and boutique shops.", category: :leisure },
    { name: "Parc de Belleville", address: "47 Rue des Couronnes, 75020 Paris", description: "Park with panoramic city views, quiet corners, and playgrounds.", category: :leisure },
    { name: "Promenade du Quai Branly", address: "75007 Paris", description: "Riverfront walk along the museum with sculptures and views of the Eiffel Tower.", category: :leisure },

    # --- Nightlife ---
    { name: "Moulin Rouge", address: "82 Boulevard de Clichy, 75018 Paris", description: "Legendary cabaret of feathers and sequins—the home of the French cancan.", category: :nightlife },
    { name: "Rex Club", address: "5 Boulevard Poissonnière, 75002 Paris", description: "Temple of Paris’s electronic scene with curated line-ups for techno lovers.", category: :nightlife },
    { name: "Le Baron", address: "6 Avenue Marceau, 75008 Paris", description: "Exclusive nightclub with chic crowd and iconic DJ sets.", category: :nightlife },
    { name: "La Bellevilloise", address: "19-21 Rue Boyer, 75020 Paris", description: "Concerts, exhibitions, and parties in a former factory space.", category: :nightlife },
    { name: "Experimental Cocktail Club", address: "37 Rue Saint-Sauveur, 75002 Paris", description: "Trendy bar with creative cocktails and a lively atmosphere.", category: :nightlife },
    { name: "Le Perchoir", address: "14 Rue Crespin du Gast, 75011 Paris", description: "Rooftop bar with panoramic city views and stylish cocktails.", category: :nightlife },
    { name: "L’Arc Paris", address: "12 Rue de Presbourg, 75016 Paris", description: "Upscale nightclub near Arc de Triomphe with a glamorous vibe.", category: :nightlife },
    { name: "Chez Moune", address: "33 Rue Saintonge, 75003 Paris", description: "Intimate cocktail bar with vintage Parisian style.", category: :nightlife },
    { name: "Badaboum", address: "2 bis Rue des Taillandiers, 75011 Paris", description: "Club and live venue mixing electronic music with eclectic performances.", category: :nightlife },
    { name: "La Machine du Moulin Rouge", address: "90 Boulevard de Clichy, 75018 Paris", description: "Club hosting DJ sets and concerts, combining modern beats with historic cabaret energy.", category: :nightlife }
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

# --- Attach Cloudinary photos to Activities ---

PHOTO_URLS = {
  # --- Culture ---
  "Musée d'Orsay" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Musee_d_Orsay_Paris.jpg",
  "Panthéon" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Pantheon_Paris.jpg",
  "Opéra Garnier" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Opera_Garnier_Paris.jpg",
  "Musée Rodin" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Musee_Rodin_Paris.jpg",
  "Musée Picasso" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Musee_Picasso_Paris.jpg",
  "Sainte-Chapelle" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Sainte_Chapelle_Paris.jpg",
  "Palais de Tokyo" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Palais_de_Tokyo_Paris.jpg",
  "Petit Palais" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Petit_Palais_Paris.jpg",
  "Maison de Victor Hugo" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Maison_Victor_Hugo_Paris.jpg",
  "Musée de l'Orangerie" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Musee_Orangerie_Paris.jpg",

  # --- Nature ---
  "Jardin des Tuileries" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Jardin_des_Tuileries_Paris.jpg",
  "Parc Monceau" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Parc_Monceau_Paris.jpg",
  "Parc de la Villette" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Parc_de_la_Villette_Paris.jpg",
  "Parc André Citroën" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Parc_Andre_Citroen_Paris.jpg",
  "Île aux Cygnes" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Ile_aux_Cygnes_Paris.jpg",
  "Bois de Vincennes" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Bois_de_Vincennes_Paris.jpg",
  "Jardin des Plantes" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Jardin_des_Plantes_Paris.jpg",
  "Parc Floral de Paris" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Parc_Floral_Paris.jpg",
  "Square du Vert-Galant" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Square_Vert_Galant_Paris.jpg",
  "Promenade Plantée" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Promenade_Plantée_Paris.jpg",

  # --- Sport ---
  "Stade de France" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Stade_de_France.jpg",
  "Accor Arena" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Accor_Arena_Paris.jpg",
  "Roland Garros" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Roland_Garros_Paris.jpg",
  "Paris Jean-Bouin Stadium" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Jean_Bouin_Stadium_Paris.jpg",
  "Piscine Molitor" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Piscine_Molitor_Paris.jpg",
  "Velodrome de Vincennes" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Velodrome_Vincennes_Paris.jpg",
  "La Coulée Verte Cyclable" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Coulee_Verte_Paris.jpg",
  "Golf de Paris Longchamp" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Golf_Paris_Longchamp.jpg",
  "Parc de Choisy Sports Complex" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Parc_Choisy_Sports.jpg",
  "Skatepark du Quai de la Gare" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Skatepark_Quai_Gare_Paris.jpg",

  # --- Relaxation ---
  "Spa NUXE Montorgueil" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Spa_NUXE_Paris.jpg",
  "Hammam Pacha" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Hammam_Pacha_Paris.jpg",
  "Institut Dior Spa" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Institut_Dior_Spa_Paris.jpg",
  "Calicéo Spa" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Caliceo_Spa_Paris.jpg",
  "Deep Nature Spa" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Deep_Nature_Spa_Paris.jpg",
  "Spa My Blend by Clarins" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/My_Blend_Spa_Paris.jpg",
  "Les Cent Ciels Spa" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Les_Cent_Ciels_Spa_Paris.jpg",
  "Cinq Mondes Spa" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Cinq_Mondes_Spa_Paris.jpg",
  "Spa L’Occitane" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Spa_LOccitane_Paris.jpg",
  "Hôtel Molitor Spa" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Hotel_Molitor_Spa_Paris.jpg",

  # --- Food ---
  "Marché des Enfants Rouges" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Marche_Enfants_Rouges_Paris.jpg",
  "Rue Montorgueil" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Rue_Montorgueil_Paris.jpg",
  "La Rue Cler" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Rue_Cler_Paris.jpg",
  "Marché Bastille" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Marche_Bastille_Paris.jpg",
  "Marché Saint-Quentin" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Marche_Saint_Quentin_Paris.jpg",
  "Rue Mouffetard Food Street" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Rue_Mouffetard_Paris.jpg",
  "Marché d’Aligre" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Marche_Aligre_Paris.jpg",
  "Rue de la Huchette" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Rue_de_la_Huchette_Paris.jpg",
  "La Grande Épicerie" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Grande_Epicerie_Paris.jpg",
  "Marché des Batignolles" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Marche_Batignolles_Paris.jpg",

  # --- Leisure ---
  "Montmartre Walking Tour" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Montmartre_Walk_Paris.jpg",
  "Batobus (Seine Hop-On Hop-Off Boat)" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Batobus_Paris.jpg",
  "Paris Open-Air Cinema" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Open_Air_Cinema_Paris.jpg",
  "Picasso Sculpture Garden" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Picasso_Sculpture_Garden_Paris.jpg",
  "Latin Quarter Stroll" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Latin_Quarter_Paris.jpg",
  "Île Saint-Louis Exploration" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Ile_Saint_Louis_Paris.jpg",
  "Canal Saint-Martin Walk" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Canal_Saint_Martin_Paris.jpg",
  "Parc de Belleville" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Parc_de_Belleville_Paris.jpg",
  "Promenade du Quai Branly" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Quai_Branly_Paris.jpg",

  # --- Nightlife ---
  "Le Baron" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Le_Baron_Paris.jpg",
  "La Bellevilloise" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/La_Bellevilloise_Paris.jpg",
  "Experimental Cocktail Club" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Experimental_Cocktail_Club_Paris.jpg",
  "Le Perchoir" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Le_Perchoir_Paris.jpg",
  "L’Arc Paris" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/LArc_Paris.jpg",
  "Chez Moune" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Chez_Moune_Paris.jpg",
  "Badaboum" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/Badaboum_Paris.jpg",
  "La Machine du Moulin Rouge" => "https://res.cloudinary.com/dontr5flw/image/upload/v1755720106/La_Machine_Moulin_Rouge_Paris.jpg"
}

puts "Attaching Cloudinary photos to Activities…"
PHOTO_URLS.each do |activity_name, url|
  act = Activity.find_by(name: activity_name)
  unless act
    warn "⚠️ Not found: #{activity_name}"
    next
  end

  # Décommente si tu veux remplacer une photo existante
  # act.photo.purge if act.photo.attached?

  next if act.photo.attached?

  file = URI.open(url)
  act.photo.attach(
    io: file,
    filename: File.basename(URI.parse(url).path),
    content_type: "image/jpeg"
  )
  puts "✔ Attached: #{activity_name}"
rescue => e
  warn "⚠️ #{activity_name}: #{e.message}"
end

end
