# ScoutUI

The ScoutUI gem provides a simple, yet powerful visual test framework to help you and your team with an automated visual test strategy.

This project is still in beta, but working - the version '1.0.0' will be the first "stable" release.

## What does ScoutUI provide?

    1. Command driven test strategy using YAML and/or JSON format
    2. Integration with Applitools Eyes (this is optional - only if you have an Eyes account)
    3. Leverage Selenium/WebDriver without having to hassle with it (e.g. APIs) to conduct browser testing
       a. UI Regression with Eyes
       b. Functional Testing
    
    
## Helpful Links
    YouTube

## Installation

### Prerequisites
    1. Ruby 1.9.3 or higher
    2. Following Gems
       a. selenium-webdriver
       b. eyes_selenium
       c. yaml
       d. json
       e. testmgr

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
    
To run a specific unit test:

    $ rspec spec/json_spec.rb

## Running the examples

Following these steps to get started.

1. Goto the ./examples/ex1 folder
2. Set the environment variable APPLITOOLS_API_KEY with your key

    export APPLITOOLS_API_KEY=[__YOUR_APPLITOOLS_KEY__]
3. Set the environment variable SCOUTUI_BIN to the ScoutUi driver
    
    export SCOUTUI_BIN=[ScoutUI Path]\bin\scoutui_driver.rb
   
4. Run the script 'test-simple.sh'
5. Goto your Applitools account and look for the test named "Graceland"

## Development


## Creating Tests

### Command files
Command files are currently supported only in YAML format, however JSON will be supported very shortly (by 10/28/2015).

Each stanza of a Command YAML file starts with the key *page*

    page:
    
and can have the following *properties*

    name: <String>
used to name the snapshot stored in Applitools.  
The string, representing the logical name of this window/validation point will appear in the test result report.

    url: <Full URL>
    
specifies the URL to load right before the snapshot

    url: <Partial URL>
    
    
specifies the partial URL that should be concatenated to the provided host, before the snapshot
    
    
    skip: <true | false>
specifies whether or not to skip this stanza  (if skip is omitted, it's default value is true)
   



#### Example 1. Navigate to a URL then take snapshots after user actions (e.g. mouse events).

    page:
      name: Home
      url: http://www.elvis.com
    ---
    page:
      name: Mouseover Music
      action: mouseover(//ul[@class="nav-primary"]//a[text()="Music"])
      snapit: true
    ---
    page:
      name: Studio Albums
      action: click(//*[@id='music']//a[text()="Studio Albums"])
      snapit: true
      expected:
        wait: //footer[@id="footer"]//a[@class="credits"]
        

## A word about using Applitools Eyes

1. CSS Transitions
    
    This method is to make the floating bar not captured when scrolling the screen in force-to-fullscreen mode.
        use_css_transition
2. Viewport

    You can obtain the viewport by resizing the browser, to a desired width/height, then obtain the following values using Javascript console.
   
        window.innerWidth
        window.innerHeight
        
        
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

