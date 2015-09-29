require 'rubygems'

##
# 1. q_applitools
# 2. q_accounts

module Scoutui::Base

  class VisualTestFramework

    def initialize()

    end


    def self.processExpected(my_driver, e)
      puts "\to Expected:  #{e['page']['expected'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      if e['page'].has_key?('expected')
        expected_list=e['page']['expected']

        expected_list.each_pair do |link_name, xpath|
          puts "\t\t#{link_name} => #{xpath}" if Scoutui::Utils::TestUtils.instance.isDebug?

          obj = Scoutui::Base::QBrowser.getObject(my_driver, xpath)

          if obj.nil?
            puts " NOT FOUND : #{link_name} with xpath #{xpath}"
          else
            puts " link object(#{link_name} with xpath #{xpath}=> #{obj.displayed?}"
          end

        end
      end
    end


    def self.processCommand(_action, e, my_driver)
      puts __FILE__ + (__LINE__).to_s + " Process ACTION : #{_action}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      if !_action.match(/type\(/).nil?
        _xpath = _action.match(/type\((.*),\s*/)[1].to_s
        _val   = _action.match(/type\(.*,\s*(.*)\)/)[1].to_s

        puts __FILE__ + (__LINE__).to_s + "Process TYPE #{_val} into  #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        obj = Scoutui::Base::QBrowser.getObject(my_driver, _xpath)
        if !obj.nil? && !obj.attribute('type').downcase.match(/(text|password)/).nil?

          obj.send_keys(Scoutui::Base::UserVars.instance.get(_val))
        end

      end

      if !_action.match(/click\(/).nil?
        _xpath = _action.match(/click\s*\((.*)\)/)[1].to_s.strip
        puts __FILE__ + (__LINE__).to_s + " click => #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?
        obj = Scoutui::Base::QBrowser.getObject(my_driver, _xpath)
        obj.click

        processExpected(my_driver, e)
      end

    end

    # Scoutui::Base::VisualTestFramework.processFile(@drv, @eyes, @test_settings['host'], @test_settings['dut'])
    def self.processFile(my_driver, eyes, test_settings)

      baseUrl = Scoutui::Base::UserVars.instance.getHost()
      datafile = test_settings['dut']

      puts __FILE__ + (__LINE__).to_s + " processFile(#{my_driver}, #{eyes}, #{baseUrl}, #{datafile})" if Scoutui::Utils::TestUtils.instance.isDebug?

      i=0
      dut_dupes = YAML.load_stream File.read(datafile)
      dut_dupes.each do |e|
        puts '-' * 72 if Scoutui::Utils::TestUtils.instance.isDebug?
        puts "#{i.to_s}. Processing #{e.inspect}" if Scoutui::Utils::TestUtils.instance.isDebug?
        i+=1

        _action = e["page"]["action"]
        _name = e["page"]["name"]
        _url = e["page"]["url"]
        _skip = e["page"]["skip"]

        if Scoutui::Utils::TestUtils.instance.isDebug?
          puts __FILE__ + (__LINE__).to_s + " action: #{_action}"
          puts __FILE__ + (__LINE__).to_s + " name: #{_name}"
          puts __FILE__ + (__LINE__).to_s + " url : #{_url}"
          puts __FILE__ + (__LINE__).to_s + " skip: #{_skip}"
        end

        skipIt = (!_skip.nil?) && (_skip.to_s.strip.downcase=='true')
        puts "\to skip : #{skipIt}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if skipIt
          puts __FILE__ + (__LINE__).to_s + " SKIP - #{_name}" if Scoutui::Utils::TestUtils.instance.isDebug?
          next
        end

        if !(_action.nil? || _action.empty?)
          processCommand(_action, e, my_driver)
          next
        end

        _relativeUrl = _url.strip.start_with?('/')

        url = e["page"]["url"].to_s

        if _relativeUrl
          puts __FILE__ + (__LINE__).to_s + " [relative url]: #{baseUrl} with #{url}"  if Scoutui::Utils::TestUtils.instance.isDebug?
          url = baseUrl + url
        end

        name = e["page"]["name"].to_s
        my_driver.navigate().to(url)


        puts "\to Expected:  #{e['page']['expected'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        if e['page'].has_key?('expected')
          expected_list=e['page']['expected']

          expected_list.each_pair do |link_name, xpath|
            puts "\t\t#{link_name} => #{xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

            obj = Scoutui::Base::QBrowser.getObject(my_driver, xpath)

            if obj.nil?
              puts __FILE__ + (__LINE__).to_s + " NOT FOUND : #{link_name} with xpath #{xpath}"
            else
              puts __FILE__ + (__LINE__).to_s + " link object(#{link_name} with xpath #{xpath}=> #{obj.displayed?}"  if Scoutui::Utils::TestUtils.instance.isDebug?
            end

          end
        end

        eyes.check_window(name)  if Scoutui::Utils::TestUtils.instance.eyesEnabled?

        puts "\to links : #{e['page']['links'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        if e['page'].has_key?('links')
          links=e['page']['links']

          links.each_pair do |link_name, xpath|
            puts "\t\t#{link_name} => #{xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?


            obj = QBrowser.getObject(my_driver, xpath)
            puts __FILE__ + (__LINE__).to_s + " [click]: link object => #{obj.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?
            obj.click

            eyes.check_window(link_name)  if Scoutui::Utils::TestUtils.instance.eyesEnabled?
          end
        end

        #
      end


    end

  end


end
