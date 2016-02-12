
require 'eyes_selenium'
require 'httparty'


module Scoutui::Base

  class QApplitools


    attr_accessor :eyes

    def initialize
      @eyes=nil
    end


    def setup
      @eyes = Applitools::Eyes.new
      # This is your api key, make sure you use it in all your tests.
      @eyes.api_key = "API_KEY"

      # Get a selenium web driver object.
      @driver = Selenium::WebDriver.for :chrome
      #Eyes.log_handler = Logger.new(STDOUT)
    end

    # Called after every test method runs. Can be used to tear
    # down fixtures information.

    def teardown
      @eyes.abort_if_not_closed
    end

    def report(results)
      download_diffs(results, "VIEW_KEY", '/tmp/diff_images')
    end

    # Fake test
    def xxxtestit
      #@eyes.baseline_name='my_test_name'
      wrapped_driver = @eyes.open(
          app_name: 'Applitools website',
          test_name: 'Example test',
          viewport_size: {width: 900, height: 650},
          driver: @driver)
      wrapped_driver.get 'https://www.applitools.com'
      # Visual validation point #1
      @eyes.check_window('Main Page')

      wrapped_driver.find_element(:css, ".features>a").click
      # Visual validation point #2
      @eyes.check_window('Features Page')
      results = @eyes.close(false)

      download_diffs(results, "VIEW_KEY", './diff_images')
      print_results(results, "VIEW_KEY")
    end

    def print_results(results, view_key)
      if results.is_passed
        print "Your test was passed!\n"
      elsif results.is_new
        print "Created new baseline, this is a new test or/and new configuration!"
      else
        print "Your test was failed!\n"
        print "#{results.mismatches} out of #{results.steps} steps failed \n"
        print "Here are the failed steps:\n"
        session_id = get_session_id(results.url)
        diff_urls = get_diff_urls(session_id, view_key)
        diff_urls.each do |index, diff_url|
          print "Step #{index} --> #{diff_url} \n"
        end
        print "For more details please go to #{results.url} to review the differences! \n"
      end
    end

    def download_diffs(results, view_key, destination)
      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " download_diffs()"

      session_id = get_session_id(results.url)
      diff_urls = get_diff_urls(session_id, view_key)
      download_images(diff_urls, destination)
    end

    def download_images(diff_urls, destination)
      diff_urls.each do |index, url|
        File.open("#{destination}/step_#{index}_diff.png", 'wb') do |file|
          file.write HTTParty.get(url)
        end
      end
    end

    def get_diff_urls(session_id, view_key)
      info = "https://eyes.applitools.com/api/sessions/#{session_id}/?ApiKey=#{view_key}&format=json"
      diff_template = "https://eyes.applitools.com/api/sessions/#{session_id}/steps/%s/diff?ApiKey=#{view_key}"
      diff_urls = Hash.new

      Scoutui::Logger::LogMgr.instance.debug __FILE__ + (__LINE__).to_s + " info => #{info}"
      response = HTTParty.get(info)

      begin
        data = JSON.parse(response.body)
        index = 1
        data['actualOutput'].each do |elem|
          if (elem['isMatching'] == false)
            diff_urls[index] = diff_template % [index]
            index+=1
          end
        end

        diff_urls

      rescue JSON::ParserError
        ;
      end

    end

    def get_session_id(url)
      /sessions\/(?<session>\d+)/.match(url)[1]
    end

  end


end
