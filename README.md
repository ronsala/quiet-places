# QuietPlaces

A quiz game. Challenge your vocabulary! Given a random word, choose the correct definition from a list. Option to see word origin.

You can read a blog post about the writing of this gem at <https://ronsala.net/makefile_002_cli_data_gem--notes_to_a_junior_to_me_dev>.

Add env token for admin privileges?

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quiet-places'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quiet-places

## Usage

Start the program in your terminal with `ruby bin/quiet-places`. On starting, WordWise will choose a word and several definitions, one of which is correct. (This process may take a few seconds). Once you've made your choice, type the corresponding number and hit 'enter'. WordWise will tell you if you're correct and, if not, the correct definition. Type 'o' and 'enter' to see the word's origin (etymology) or 'n' and 'enter' for the next question. To exit the game, type 'e' and 'enter'. Watch a video demo at <https://bit.ly/2Kz8zgX>.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ronsala/quiet-places. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the QuietPlaces project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ronsala/quiet-places/blob/master/CODE_OF_CONDUCT.md).
