require 'faker'

  # ménage
  Opening.destroy_all
  Box.destroy_all
  User.destroy_all
  puts "Ménage effectué !"

  users    = []
  boxes    = []
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
  puts "Users générés !"

  300.times do
    b = Box.new
    b.title = Faker::Book.title
    b.content = Faker::Lorem.paragraph(2)
    b.latitude = Faker::Address.latitude
    b.longitude = Faker::Address.longitude
    b.expiration_date_time = Faker::Time.between(DateTime.now - 7, DateTime.now + 7)
    b.icon = Faker::SlackEmoji
    b.openings_max = rand(1..2) == 1 ? nil : rand(1..7) # 1 fois sur 2, pas de nb limite
    b.user = users.sample
    b.save
    boxes << b
  end
  puts "Boxs générées !"

  500.times do
    o = Opening.new
    o.box = boxes.sample
    o.user = users.sample
    o.rating = rand(1..4) == 1 ? nil : rand(0..5) # 1 fois sur 4, pas de rating laissé
    o.save
    openings << o
  end
  puts "Openings générées !"

# p users
# p boxes
# p openings
