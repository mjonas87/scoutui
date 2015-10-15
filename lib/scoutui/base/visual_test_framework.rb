

module Scoutui::Base

  class VisualTestFramework

    def initialize()

    end


    def self.isClick?(_action)
      !_action.match(/click\(/).nil?
    end

    def self.isMouseOver(_action)
      !_action.match(/mouseover\(/).nil?
    end


    def self.processCommand(_action, e, my_driver)
      puts __FILE__ + (__LINE__).to_s + " Process ACTION : #{_action}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      if !_action.match(/pause/).nil?

        puts " PAUSE";
        gets();

      elsif !_action.match(/type\(/).nil?
        _xpath = _action.match(/type\((.*),\s*/)[1].to_s
        _val   = _action.match(/type\(.*,\s*(.*)\)/)[1].to_s

        puts __FILE__ + (__LINE__).to_s + "Process TYPE #{_val} into  #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        obj = Scoutui::Base::QBrowser.getObject(my_driver, _xpath)

        if !obj.nil? && !obj.attribute('type').downcase.match(/(text|password)/).nil?
          obj.send_keys(Scoutui::Base::UserVars.instance.get(_val))
        else
          puts __FILE__ + (__LINE__).to_s + " Unable to process command TYPE => #{obj.to_s}"
        end

      end

      if !_action.match(/click\(/).nil?
        _xpath = _action.match(/click\s*\((.*)\)/)[1].to_s.strip
        puts __FILE__ + (__LINE__).to_s + " click => #{_xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        _xpath = Scoutui::Base::UserVars.instance.get(_xpath)

        puts __FILE__ + (__LINE__).to_s + " | translate : #{_xpath}" if Scoutui::Utils::TestUtils.instance.isDebug?

        obj = Scoutui::Base::QBrowser.getObject(my_driver, _xpath)
        obj.click if obj
      elsif isMouseOver(_action)
        _xpath = _action.match(/mouseover\s*\((.*)\)/)[1].to_s.strip
        obj = Scoutui::Base::QBrowser.getObject(my_driver, _xpath)
        my_driver.action.move_to(obj).perform

      end

    end

    def self.isRun(e)
      _run=nil
      if e["page"].has_key?("run")
        _run = e["page"].has_key?("run").to_s
      end
      _run
    end

    def self.isSnapIt(e)
      _snapit=false

      if e["page"].has_key?("snapit")
        _snapit = !(e["page"]["snapit"].to_s.match(/true/i).nil?)
      end
      _snapit
    end

    def self.processExpected(my_driver, e)
      puts __FILE__ + (__LINE__).to_s + "\to Expected:  #{e['page']['expected'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

      if e['page'].has_key?('expected')
        expected_list=e['page']['expected']

        expected_list.each_pair do |link_name, xpath|
          puts "\t\t#{link_name} => #{xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?
          if !xpath.match(/^page\([\w\d]+\)/).nil?

            xpath = Scoutui::Utils::TestUtils.instance.getPageElement(xpath)
            puts __FILE__ + (__LINE__).to_s + " Process page request #{xpath} => #{xpath}" if Scoutui::Utils::TestUtils.instance.isDebug?
          end

          obj = Scoutui::Base::QBrowser.getFirstObject(my_driver, xpath)

          if obj.nil?
            puts " NOT FOUND : #{link_name} with xpath #{xpath}"
          else
            puts " link object(#{link_name} with xpath #{xpath}=> #{obj.displayed?}"  if Scoutui::Utils::TestUtils.instance.isDebug?
          end

        end
      end
    end

    # Scoutui::Base::VisualTestFramework.processFile(@drv, @eyes, @test_settings['host'], @test_settings['dut'])
    def self.processFile(eyeScout, test_settings)

      my_driver = eyeScout.drv()

      baseUrl = Scoutui::Base::UserVars.instance.getHost()
      datafile = test_settings['dut']

      puts __FILE__ + (__LINE__).to_s + " processFile(#{eyeScout}, #{baseUrl}, #{datafile})" if Scoutui::Utils::TestUtils.instance.isDebug?

      valid_file=false
      i=0
      begin
        dut_dupes = YAML.load_stream File.read(datafile)
        valid_file=true
      rescue => ex
        puts __FILE__ + (__LINE__).to_s + " Invalid file: #{datafile} - abort processing."
        puts ex.backtrace
      end

      return if !valid_file

      dut_dupes.each do |e|
        puts '-' * 72 if Scoutui::Utils::TestUtils.instance.isDebug?
        puts "#{i.to_s}. Processing #{e.inspect}" if Scoutui::Utils::TestUtils.instance.isDebug?
        i+=1

        _action = e["page"]["action"]
        _name = e["page"]["name"]
        _url = e["page"]["url"]
        _skip = e["page"]["skip"]
        _region = e["page"]["region"]


        if Scoutui::Utils::TestUtils.instance.isDebug?
          puts __FILE__ + (__LINE__).to_s + " action: #{_action}"
          puts __FILE__ + (__LINE__).to_s + " name: #{_name}"
          puts __FILE__ + (__LINE__).to_s + " url : #{_url}"
          puts __FILE__ + (__LINE__).to_s + " skip: #{_skip}"
          puts __FILE__ + (__LINE__).to_s + " region: #{_region}"
        end

        skipIt = (!_skip.nil?) && (_skip.to_s.strip.downcase=='true')
        puts "\to skip : #{skipIt}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if skipIt
          puts __FILE__ + (__LINE__).to_s + " SKIP - #{_name}" if Scoutui::Utils::TestUtils.instance.isDebug?
          next
        end


        if !isRun(e).nil?

          tmpSettings=test_settings.dup
          tmpSettings["dut"]=e["page"]["run"].to_s

          processFile(eyeScout, tmpSettings)
          puts __FILE__ + (__LINE__).to_s + " Completed execution of subfile"  if Scoutui::Utils::TestUtils.instance.isDebug?
          next
        end

        if !(_action.nil? || _action.empty?)
          processCommand(_action, e, my_driver)
          processExpected(my_driver, e)

          if isSnapIt(e)
            if !_region.nil?
              eyeScout.check_window(_name, _region)
            else
              eyeScout.check_window(_name)
            end

           # processExpected(my_driver, e)
          end

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

        processExpected(my_driver, e)

        if false

        if e['page'].has_key?('expected')
          expected_list=e['page']['expected']

          expected_list.each_pair do |link_name, xpath|
            puts "\t\t#{link_name} => #{xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?

            if !xpath.match(/^page\([\w\d]+\)/).nil?


              xpath = Scoutui::Utils::TestUtils.instance.getPageElement(xpath)

              puts __FILE__ + (__LINE__).to_s + " Process page request #{xpath} => #{xpath}"

            end

            obj = Scoutui::Base::QBrowser.getObject(my_driver, xpath)

            if obj.nil?
              puts " NOT FOUND : #{link_name} with xpath #{xpath}"
            else
              puts " link object(#{link_name} with xpath #{xpath}=> #{obj.displayed?}"  if Scoutui::Utils::TestUtils.instance.isDebug?
            end

          end
        end


        end


        if !_region.nil?
          eyeScount.check_window(_name, _region)
        else
          eyeScout.check_window(name)
        end

        puts "\to links : #{e['page']['links'].class.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?

        if e['page'].has_key?('links')
          links=e['page']['links']

          links.each_pair do |link_name, xpath|
            puts "\t\t#{link_name} => #{xpath}"  if Scoutui::Utils::TestUtils.instance.isDebug?


            obj = QBrowser.getObject(my_driver, xpath)
            puts __FILE__ + (__LINE__).to_s + " [click]: link object => #{obj.to_s}"  if Scoutui::Utils::TestUtils.instance.isDebug?
            obj.click

            if !_region.nil?
              eyeScount.check_window(_name, _region)
            else
              eyeScout.check_window(link_name)
            end

          end
        end

      end


    end

  end


end
