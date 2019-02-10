# QuietPlaces

Find where to converse and relax, in peace. Read reviews of restaurants and bars and make your own. QuietPlaces is an MVC Sinatra content management system that allows users to find quality places without the noise that can prevent people from hearing others and being heard and detract from their enjoyment.

# [] You can read a blog post about the creation of QuietPlaces at
< urlHere >

## Installation

You can either clone the repository directly from GitHub into a local directory on your computer or you can Fork the app so that you can contribute to the code.

Once you Fork or Clone this app, cd into that directory and then execute:

*bash:*

```bash
bundle install
rake db:migrate
```

Because the app uses the Dotenv gem for environment variable for security, create a file in the top level of the directory, with a .env extension. This file should not be checked into a public repository. In this file, set the values you want to ensure user and admin login secrets, which will be accessible in the ENV hash. For example:

*config.env:*

```
SECRET_KEY=YOURSECRETKEYHERE
ADMIN_KEY=YOURADMINKEYHERE
```

Then,

*bash:*

```bash
export SECRET_KEY=YOURSECRETKEYHERE
export ADMIN_KEY=YOURADMINKEYHERE
```

Please note, the included tests specify the ADMIN_KEY as "149162". Either use this value while testing or change the value in the tests in your fork.

For further documentation on Dotenv, see
<https://github.com/bkeepers/dotenv/blob/master/README.md>

## Usage

*bash:*

```bash
shotgun
```

Click on the link that Shotgun shows you in your terminal to open up the app in your browser.

You can watch a video demo at
< urlHere >.

## Running the tests

*bash:*

```bash
rspec spec/quiet_places_spec.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ronsala/quiet-places. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

This app is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the QuietPlaces project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ronsala/quiet-places/blob/master/CODE_OF_CONDUCT.md).
