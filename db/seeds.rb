require 'faker'

  # ménage
  Opening.destroy_all
  Box.destroy_all
  User.destroy_all
  puts "Ménage effectué !"

  users    = []
  b1, b2, b3, b4 = [], [], [], []
  openings = []

  100.times do
    u = User.new
    u.last_name  = Faker::Name.last_name.upcase
    u.first_name = Faker::Name.first_name.capitalize
    u.email = Faker::Internet.email
    u.password = 'totototo'
    u.save
    users << u
  end
  puts "#{users.count} users générés !"

  def create_boxes(min_lat, max_lat, min_lng, max_lng, number, reach, users)
    res = Array.new
    number.times do
      b = Box.new
      b.title = Faker::Book.title
      b.content = "#{Faker::Lorem.paragraph(2)}\n#{Faker::Internet.url}"
      b.latitude = rand(min_lat..max_lat)
      b.longitude = rand(min_lng..max_lng)
      b.expiration_date_time = Faker::Time.between(DateTime.now - 7, DateTime.now + 7)
      b.icon = Faker::SlackEmoji.emoji
      b.openings_max = rand(1..2) == 1 ? nil : rand(1..7) # 1 fois sur 2, pas de nb limite
      b.user = users.sample
      b.save
      res << b
    end
    puts "#{res.length} boxes générées (#{reach})"
    res
  end

  b1 = create_boxes(-35.00000, 50.00000, -120.000, 145.000,  100, "world",     users)
  b2 = create_boxes(44.00000,  50.00000, -5.00000, 9.00000,  200, "france",    users)
  b3 = create_boxes(44.00000,  45.50000, -1.15000, 1.02000,  200, "aquitaine", users)
  b4 = create_boxes(44.81000,  44.86000, -0.60320, -0.52450, 300, "bordeaux",  users)

  (b1 << b2 << b3 << b4).flatten!
  puts "(#{b1.count} boxs au total)"

  800.times do
    o = Opening.new
    o.box = b1.sample
    o.user = users.sample
    o.rating = rand(1..4) == 1 ? nil : rand(0..5) # 1 fois sur 4, pas de rating laissé
    o.save
    openings << o
  end
  puts "#{Opening.all.count} openings générées !"

# p users
# p b1
# p b2
# p b3
# p b4
# p openings
