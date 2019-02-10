# QuietPlaces

Find where to converse and relax, in peace. Read reviews of restaurants and bars and make your own. QuietPlaces is an MVC Sinatra content management system that allows users to find quality places without the noise that can prevent people from hearing others and being heard and detract from their enjoyment.

# [] You can read a blog post about the creation of QuietPlaces at
< urlHere >

## Installation

You can either clone the repository directly from GitHub into a local directory on your computer or you can Fork the app so that you can contribute to the code.

Once you Fork or Clone this app, cd into that directory and then execute:

  $ bundle install
  $ rake db:migrate
  $ export SECRET_KEY=QUIETPLEASE
  $ export ADMIN_KEY=149162

## Usage

   $ shotgun

Click on the link that Shotgun shows you in your terminal to open up the app in your browser.

You can watch a video demo at
< urlHere >.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ronsala/quiet-places. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the QuietPlaces project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ronsala/quiet-places/blob/master/CODE_OF_CONDUCT.md).
