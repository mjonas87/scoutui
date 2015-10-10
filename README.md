# Scoutui

The ScoutUI gem provides a simple, yet powerful visual test framework to help you and your team with an automated visual test strategy.

This project is still under beta development, but working - the version '1.0.0' will be the first "stable" release.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scoutui'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scoutui
    
To run unit tests:

    $ bundle exec rake spec

## Usage

Following these steps to get started.

1. goto the ./test folder
2. Set the environment variable APPLITOOLS_API_KEY with your key

   export APPLITOOLS_API_KEY=<your key>
3. Run the script 'test-simple.sh'
4. Goto your Applitools account and look for the test named "Graceland"

## Development


## To run from the command line

ruby test_script.rb  --config <your test settings JSON file> --eyes


After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/h20dragon/scoutui.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## To do

Advanced Test Reporting

