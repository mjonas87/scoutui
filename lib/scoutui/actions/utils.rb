
require 'singleton'

module Scoutui::Actions


  class Utils
    include Singleton

    attr_accessor :totalActions
    attr_accessor :timeout
    attr_accessor :hwnds

    def initialize
      @command_list=['pause',
                     'existsAlert',
                     'fillform',
                     'submitform',
                     'type',
                     'click',
                     'mouseover',
                     'navigate',
                     'select',
                     'select_window',
                     'verifyelt',
                     'verifyelement',
                     'verifyform']
      @totalActions={}
      @timeout=5
      @command_list.each do |c|
        @totalActions[c]=0
      end

      @hwnds = { :current => nil, :previous => nil, :handles => [] }
    end


    def isCSS(_locator)
      rc=nil

      if _locator.match(/^css\=/i)
        rc = _locator.match(/\s*(css\=.*)/i)[1].to_s.strip
      elsif _locator.match(/^#/i)
        rc=_locator.strip
      end

      rc
    end


    def setCurrentWindow(_w)
      if @hwnds[:previous].nil?
        @hwnds[:previous]=_w
      else
        @hwnds[:previous]=@hwnds[:current]
      end

      @hwnds[:current]=_w
    end

    def resetTimeout()
      setTimeout(5)
    end

    def setTimeout(_t)
      @timeout=_t
    end
    def getTimeout()
      @timeout
    end

    def isSelectWindow?(_action)
      !_action.match(/select_window/i).nil?
    end

    def isExistsAlert?(_action)
      !_action.match(/(exist[s]*_*alert|existAlert|existsAlert|existsJsAlert|existsJsConfirm|existsJsPrompt)\(/i).nil?
    end

    def isVerifyElt?(_action)
      !_action.match(/(verifyelt|verifyelement|verify_element)\(/i).nil?
    end

    def isClick?(_action)
      !_action.match(/click\(/i).nil?
    end

    def isGetAlert?(_action)
      !_action.match(/(get_*alert|clickjsconfirm|clickjsprompt|clickjsalert)/i).nil?
    end

    def isFillForm?(_action)
      !_action.match(/(fillform|fill_form)\(/i).nil?
    end

    def isMouseOver?(_action)
      !_action.match(/mouseover\(/).nil?
    end

    def isType?(_action)
      !_action.match(/type[\!]*\(/).nil?
    end

    def isSubmitForm?(_action)
      !_action.match(/(submitform|submit_form)\(/).nil?
    end

    def isVerifyForm?(_action)
      !_action.match(/(verifyform|verify_form)\(/).nil?
    end

    def isPause?(_action)
      !_action.match(/pause/).nil?
    end

    def isSelect?(_action)
      !_action.nil? && _action.match(/select/i)
    end

    def isNavigate?(_action)
      !_action.nil? && _action.match(/(navigate|url)\(/i)
    end

    def isValid?(cmd)
      rc=true

      if isPause?(cmd)
        @totalActions['pause']+=1
      elsif isExistsAlert?(cmd)
        @totalActions['existsAlert']+=1
      elsif isVerifyElt?(cmd)
        @totalActions['verifyelt']+=1
      elsif isVerifyForm?(cmd)
        @totalActions['verifyform']+=1
      elsif isFillForm?(cmd)
        @totalActions['fillform']+=1
      elsif isSubmitForm?(cmd)
        @totalActions['submitform']+=1
      elsif isType?(cmd)
        @totalActions['type']+=1
      elsif isClick?(cmd)
        @totalActions['click']+=1
      elsif isMouseOver?(cmd)
        @totalActions['mouseover']+=1
      elsif isSelect?(cmd)
        @totalActions['select']+=1
      elsif isNavigate?(cmd)
        @totalActions['navigate']+=1
      elsif isSelectWindow?(cmd)
        @totalActions['select_window']+=1
      else
        rc=false
      end

      rc
    end
  end
end
