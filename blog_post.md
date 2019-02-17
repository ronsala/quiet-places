# Makefile 003: Sinatra CMS--Learning By Doing

## *"Just keep swimming."--Disney's "Finding Nemo"*

I'm writing this time about my latest project, a content management system (CMS) built with Sinatra and ActiveRecord. It's called [QuietPlaces](https://github.com/ronsala/quiet-places), a web app allowing users to find and review restaurants and bars based on their noise level and overall quality.

I made it to satisfy my Sinatra assessment for [Flatiron School](https://flatironschool.com/). See a demo video at
<https://youtu.be/VVP6IEfmWn4>.

Making it was a marathon, not a sprint.

I had a vision of what the app should do, and since I intended to put it in the wild for actual users, I wanted it to act in a way I found acceptable. To actually release it into production would require additional work. For now, I have a functioning web app, and I feel good about it and all the learning that made it possible.

Generally, in coding education we're introduced to small lessons teaching single concepts. Eventually, each of us works from a blank editor and puts together something of our own. We must join the individual concepts to serve the intent of the project.

Since what I wanted for my project went beyond the requirements of the assignment, I needed to find out how to use techniques I'd little or no knowledge of when I started. I did a lot of Googling, experimenting, and talking with instructors from the school.

Here are some of the things I learned about (or more about) making the app:

## It's OK to change course

QuietPlaces was not my first plan. I had originally begun a scheduling app that could assign tasks at various times to health care workers. (I work in a hospital and wanted to code something practical we could use.) After talking with one of the instructors, I decided to put this effort on hold, as Sinatra didn't seem to be the best technology for it. I instead took an idea a friend expressed to me for an app he wished existed.

## Wireframing

I'd seen our dean, Avi Flombaum, demonstrate wireframing but lacked experience with it myself. I discovered [Lucidchart](https://www.lucidchart.com), which is an easy way to put together a wireframe showing the relationships between database tables in your app.

## Testing

This is the first time I'd put together a test suite. I used rspec and capybara, adapting some from Flatiron's Fwitter lab, writing some from scratch. Though it was a steep learning curve, it was worth it. Once I had tests working I could tell if my refactors broke the parts of the code they covered. It saved quite a bit of typing compared to testing manually. Also, I've heard testing is a skill employers look for.

## Ruminating on code

I thought I had my app ready to submit. I'd even recorded a video demo. After I discovered there was a problem with the recording, I deleted some sample entries I'd made so I could make the same ones in the re-recording. To my dismay, I found that one of my routes, `/reviews`, had broken.

The models in the app are User, Place, and Name. In reviews_controller I have this method:

```ruby
  get "/reviews" do
    @reviews = Review.all.sort_by { | review | [ review.place.name.downcase, review.title.downcase ] }

    erb :"/reviews/index"
  end
```

This sets `@reviews` to a list of all reviews, sorted alphabetically, first by the name of the place the review was written on, then by the title of the review.

For some reason, I was getting a NoMethodError when `.name` was called on `place`. It took me a while to understand why. While I was away from the computer, thinking/obsessing over the problem, it hit me: Since I'd deleted a place, the review it was written about was unable to supply the name of the (now-deleted) place. To prevent this recurring I refactored part of the `/get "/places/:id/delete"` route in places_controller to:

```ruby
@place.reviews.each do | review |
  review.delete
end
@place.delete
```

This deletes each of a place's reviews before deleting the place itself, making sure the reviews index doesn't come up short later.

## Summary

I learned many more things in this project than I could cover in a short blog post. Overall, the experience taught me to keep on learning, coding, debugging, rinse-and-repeat. Though I have more and more of a sense of how much I don't know, I appreciate what have learned and am excited about what I've yet to learn....