require 'faker'
puts "-"*30
# ménage
Opening.destroy_all
Box.destroy_all
User.destroy_all
puts "Existing data cleaned up!"

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
puts "- #{users.count} users seeded!"

links =
[
  "http://www.nytimes.com/2016/02/07/books/review/everything-about-everything-david-foster-wallaces-infinite-jest-at-20.html",
  "http://www.goodreads.com/book/show/50653.The_Powerbook",
  "https://www.manning.com/books/the-well-grounded-rubyist",
  "https://www.youtube.com/watch?v=7NJqUN9TClM",
  "http://www.harrypottertheplay.com/",
  "http://therubyist.com/",
  "https://en.wikipedia.org/wiki/The_Crying_of_Lot_49",
  "http://www.armisteadmaupin.com/",
  "https://en.wiktionary.org/wiki/Rubyist",
  "https://www.youtube.com/watch?v=94Rq2TX0wj4",
  "https://www.youtube.com/watch?v=TpMjSL4_Sbk",
  "https://www.youtube.com/watch?v=VNvEO-0HRUU",
  "https://www.youtube.com/watch?v=GFBnrxMh9tQ",
  "https://www.youtube.com/watch?v=Lp9GgdCgMXk",
  "https://www.youtube.com/watch?v=fIIzuqIRB2g",
  "https://www.youtube.com/watch?v=i3Jv9fNPjgk",
  "https://www.youtube.com/watch?v=GkprBmXED4o",
  "https://www.youtube.com/watch?v=ObWY2f3gHQo",
  "https://www.youtube.com/watch?v=EBAzlNJonO8",
  "https://www.youtube.com/watch?v=lS-af9Q-zvQ",
  "https://www.youtube.com/watch?v=yq5MisAmd5Q",
  "http://corporate.europages.fr/actualites/papier-et-carton-lindustrie-europeenne-se-tourne-vers-le-4-0/",
  "http://www.blogdumoderateur.com/google-update-juin-2016/",
  "http://www.liberation.fr/futurs/2016/08/02/huitres-triploides-des-douzaines-en-questions_1469940",
  "https://images-na.ssl-images-amazon.com/images/I/51ADO%2BUusAL._SX300_BO1,204,203,200_.jpg",
  "https://www.youtube.com/watch?v=0uS_fJAOhek"
]

def create_boxes(min_lat, max_lat, min_lng, max_lng, number, reach, users, links)
  res = Array.new
  number.times do
    b = Box.new
    b.title = Faker::Book.title
    b.content = "#{Faker::Lorem.paragraph(2)}\n#{links.sample}"
    b.latitude = rand(min_lat..max_lat)
    b.longitude = rand(min_lng..max_lng)
    b.expiration_date_time = Faker::Time.between(DateTime.now - 7, DateTime.now + 7)
    b.icon = Faker::SlackEmoji.emoji
    b.openings_max = rand(1..2) == 1 ? nil : rand(1..7) # 1 fois sur 2, pas de nb limite
    b.user = users.sample
    b.save
    res << b
  end
  puts "- #{res.length} boxes seeded (#{reach})!"
  res
end

b1 = create_boxes(-35.00000, 50.00000, -120.000, 145.000,  100, "world",     users, links)
b2 = create_boxes(44.00000,  50.00000, -5.00000, 9.00000,  200, "france",    users, links)
b3 = create_boxes(44.00000,  45.50000, -1.15000, 1.02000,  200, "aquitaine", users, links)
b4 = create_boxes(44.81000,  44.86000, -0.60320, -0.52450, 300, "bordeaux",  users, links)

(b1 << b2 << b3 << b4).flatten!
puts "  (total: #{b1.count} boxes seeded)"

800.times do
  o = Opening.new
  o.box = b1.sample
  o.user = users.sample
  o.rating = rand(1..4) == 1 ? nil : rand(0..5) # 1 fois sur 4, pas de rating laissé
  o.save
  openings << o
end

# initialisation
def init_counter
  execute <<-SQL.squish
      UPDATE boxes
         SET openings_count = (SELECT count(1)
                                 FROM openings
                                WHERE openings.box_id = boxes.id);
  SQL
end

puts "- #{Opening.all.count} openings seeded!"
puts "-"*30
# p users
# p b1
# p b2
# p b3
# p b4
# p openings
