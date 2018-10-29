users = [
  {username: "Emily", email: "emily@example.org"},
  {username: "Felix", email: "felix@example.org"},
  {username: "Zoe", email: "zoe@example.org"}
]

users.each do |x|
  User.create(x)
end

reviews = [
  {user_id: "1", place_id: "3" title: "Loud As Bombs", visit: "2018,6,23", tv: "true", volume: "10", quality: "9", body: "This place made my ears bleed!"},
  {user_id: "2", place_id: "1" title: "Quiet as a tomb", visit: "2018,7,29", tv: "false", volume: "0", quality: "3", body: "No sound at all here"},
  {user_id: "3", place_id: "2" title: "A pleasant buzz", visit: "2018,5,23", tv: "false", volume: "3", quality: "5", body: "I liked the low chatter."},
  {user_id: "1", place_id: "2" title: "Too loud!", visit: "2017,6,1", tv: "true", volume: "8", quality: "6", body: "They were playing a TV and a juke box at full volume! Never going back there...."},
  {user_id: "3", place_id: "2" title: "Could here a pin drop", visit: "2016,12,23", tv: "false", volume: "1", quality: "9", body: "Only the sound of breathing and chewing."}
]

reviews.each do |x|
  Review.create(x)
end

places = [
  {name: "Louie's Breakfast", street: "20 Wabash St.", city: "New Jack City", state: "UT", website: "www.louies.com"},
  {name: "Tavern On the Blue", street: "19 Cookie Monster Way", city: "Hoboken", state: "NJ", website: "www.tonb.com"}, 
  {name: "Bugs Are Yummy", street: "113 Main Ave", city: "Tampa", state: "FL", website: "www.buggy.com"}
]

places.each do |x|
  Place.create(x)
end