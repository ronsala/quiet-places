# Specifications for the Sinatra Assessment

Specs:

- [x] Use Sinatra to build the app

app/Gemfile.lock:
  sinatra (2.0.5)

- [x] Use ActiveRecord for storing information in a database

app/Gemfile.lock:
  activerecord (4.2.11)

- [x] Include more than one model class (e.g. User, Post, Category)

app/models/place.rb
app/models/review.rb
app/models/user.rb

- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts)

app/models/user.rb:
  has_many :reviews
  has_many :places

- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User)

app/models/place.rb:
  belongs_to :user

app/models/review.rb:
  belongs_to :user
  belongs_to :place

- [x] Include user accounts with unique login attribute (username or email)

app/models/user.rb:
  validates :username, :email, uniqueness: true

- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying

app/controllers/places_controller.rb:
  get "/places/new"
  post "/places"
  get "/places"
  get "/places/:id"
  

- [x] Ensure that users can't modify content created by other users
- [x] Include user input validations
- [x] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm

- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message