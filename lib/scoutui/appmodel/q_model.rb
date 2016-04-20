

module Scoutui::ApplicationModel

  class QModel
    attr_accessor :_file
    attr_accessor :app_model

    def initialize(file_name = nil)
      return if file_name.nil?
      loadPages(file_name)
    end

    def getAppModel()
      @app_model
    end

    def loadPages(file_name_or_list)
      file_list = file_name_or_list.respond_to?(:each) ? file_name_or_list : [file_name_or_list]

      @app_model = {}
      file_list.each  { |file_name|
        data_hash = YAML.load(File.read(file_name))
        @app_model.merge!(data_hash)
      }

      @app_model
    end


    # getPageElement("page(login).get(login_form).get(button)")
    def getPageElement(s)
      if s.match(/^\s*\//) || s.match(/^\s*css\s*=/i)
        return nil
      end

      hit=@app_model
      nodes = s.split(/\./)

      nodes.each { |elt|
        getter = elt.split(/\(/)[0]
        _obj = elt.match(/\((.*)\)/)[1]

        if getter.downcase.match(/(page|pg)/)
          hit=@app_model[_obj]
        elsif getter.downcase=='get'
          hit=hit[_obj]
        else
          return nil
        end
      }

      hit
    end

    # get_page_node("page(login).get(login_form).get(button)")
    def get_page_node(selector, current_node = nil)
      current_node ||= @app_model
      fail Exception, 'Current node is nil' if current_node.nil?

      if selector.match(/^\s*\//) || selector.match(/^\s*css\s*=/i)
        return nil
      end

      remaining_selectors = selector.split(/\./)
      selector = remaining_selectors.shift
      getter = selector.split(/\(/)[0]
      fail Exception, "Invalid getter method in '#{getter}'" unless getter.downcase.match(/(page|get)/)

      node_name = selector.match(/\((.*)\)/)[1]
      if remaining_selectors.any?
        get_page_node(remaining_selectors.join, current_node[node_name])
      elsif current_node.key?(node_name)
        [current_node[node_name], node_name]
      else
        fail Exception, "Unable to find #{node_name} in #{current_node}"
      end
    end

    # visible_when: hover(page(x).get(y).get(z))
    def itemize(condition='visible_when', _action='hover', _pgObj=nil)
      @results=hits(nil, @app_model, condition, _action, _pgObj)

      puts "[itemize] => #{@results}"

      @results
    end


    def hits(parent, h, condition, _action, pg)
      #  puts __FILE__ + (__LINE__).to_s + " collect_item_attributes(#{h})"
      result = []


      if h.is_a?(Hash)

        h.each do |k, v|
          puts __FILE__ + (__LINE__).to_s + " Key: #{k} => #{v}"
          if k == condition
            #  h[k].each {|k, v| result[k] = v } # <= tweak here
            if !v.is_a?(Array) && v.match(/^\s*#{_action}\s*\((.*)\)\s*$/i)

              pageObject=v.match(/^\s*#{_action}\s*\((.*)\)\s*$/i)[1]

              puts __FILE__ + (__LINE__).to_s + " <pg, pageObject> : <#{pg}, #{pageObject}>"
              #         result[k] = v

              #          puts '*******************'
              #          puts __FILE__ + (__LINE__).to_s + " HIT : #{h[k]}"
              #          result << { h[k] => v }

              if pg.nil?
                result << parent
              elsif pg == pageObject
                result << parent

              end

            elsif v.is_a?(Array)

              v.each do |vh|
                puts " =====> #{vh}"

                if vh.is_a?(Hash) && vh.has_key?(condition) && vh[condition].match(/^\s*#{_action}\s*/i)

                  pageObject=vh[condition].match(/^\s*#{_action}\s*\((.*)\)\s*$/i)[1]


                  puts __FILE__ + (__LINE__).to_s + " matched on #{_action}, pg:#{pg}, #{pageObject}"

                  if pg.nil?
                    result << parent
                  elsif pg == pageObject
                    result << parent
                  end

                end

              end

            end

          elsif v.is_a? Hash
            if parent.nil?
              _rc = hits("page(#{k})", h[k], condition, _action, pg)
            else
              _rc = hits("#{parent}.get(#{k})", h[k], condition, _action, pg)
            end


            if !(_rc.nil? || _rc.empty?)


              result << _rc

              puts __FILE__ + (__LINE__).to_s + " ADDING  #{k} : #{_rc}"
              #           puts "====> #{k} : #{_rc.class} : #{_rc.length}"


              result.flatten!
            end


          end
        end

      end



      result=nil if result.empty?
      puts __FILE__ + (__LINE__).to_s + " result : #{result}"
      result
    end



  end



end
