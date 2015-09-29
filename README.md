# Scoutui

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/scoutui`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

TODO: Write usage instructions here

## Development


## Ti ryb

ruby test_script.rb  --file ../spec/fixtures/static_test_settings.json --host rqa3 --lang en-us  --title "abc 123"  --user peter --password Hello --browser chrome  --eyes TruE


After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/scoutui. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## To do
1. Refactor test_settings handling of JSON in method setConfig() - if Hash then we're fine, otherwise load the file (where String is passed)

    jFile = File.read(static_settings_file)
    jsonData=JSON.parse(jFile)

    puts "jsonData type is #{jsonData.class.to_s}"

    t.setConfig(jsonData)

