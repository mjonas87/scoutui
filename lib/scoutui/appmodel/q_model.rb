

module Scoutui::ApplicationModel

  class QModel
    attr_accessor :_file
    attr_accessor :app_model

    def initialize(f=nil)

      if !f.nil?
        @_file=f
        loadPages(@_file)
      end

    end

    def getAppModel()
      @app_model
    end

    def loadPages(jlist)

      json_list=[]
      if jlist.kind_of?(String)
        json_list << jlist
      else
        json_list=jlist
      end

      jsonData={}
      json_list.each  { |f|
        puts __FILE__ + (__LINE__).to_s + " JSON.parse(#{f})"

        begin
          data_hash = JSON.parse File.read(f)
          jsonData.merge!(data_hash)
        rescue JSON::ParserError
          raise "JSONLoadError"
        end

      }
      puts "merged jsonData => " + jsonData.to_json
      @app_model = jsonData
    end


    # getPageElement("page(login).get(login_form).get(button)")
    def getPageElement(s)
      puts __FILE__ + (__LINE__).to_s + " getPageElement(#{s})"
      hit=@app_model

      nodes = s.split(/\./)

      nodes.each { |elt|
        getter = elt.split(/\(/)[0]
        _obj = elt.match(/\((.*)\)/)[1]

        puts __FILE__ + (__LINE__).to_s + " getter : #{getter}  obj: #{_obj}" if Scoutui::Utils::TestUtils.instance.isDebug?

        if getter.downcase.match(/(page|pg)/)
          puts __FILE__ + (__LINE__).to_s + " -- process page --"  if Scoutui::Utils::TestUtils.instance.isDebug?
          hit=@app_model[_obj]
        elsif getter.downcase=='get'
          hit=hit[_obj]
        else
          puts __FILE__ + (__LINE__).to_s + " getter : #{getter} is unknown."
          return nil
        end
        puts __FILE__ + (__LINE__).to_s + " HIT => #{hit}" if Scoutui::Utils::TestUtils.instance.isDebug?
      }

      hit

    end

  end



end
