
require 'singleton'

module Scoutui::Commands


  class Utils
    include Singleton

    attr_accessor :totalCommands
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
      @totalCommands={}
      @timeout=30
      @command_list.each do |c|
        @totalCommands[c]=0
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
      setTimeout(30)
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
        @totalCommands['pause']+=1
      elsif isExistsAlert?(cmd)
        @totalCommands['existsAlert']+=1
      elsif isVerifyElt?(cmd)
        @totalCommands['verifyelt']+=1
      elsif isVerifyForm?(cmd)
        @totalCommands['verifyform']+=1
      elsif isFillForm?(cmd)
        @totalCommands['fillform']+=1
      elsif isSubmitForm?(cmd)
        @totalCommands['submitform']+=1
      elsif isType?(cmd)
        @totalCommands['type']+=1
      elsif isClick?(cmd)
        @totalCommands['click']+=1
      elsif isMouseOver?(cmd)
        @totalCommands['mouseover']+=1
      elsif isSelect?(cmd)
        @totalCommands['select']+=1
      elsif isNavigate?(cmd)
        @totalCommands['navigate']+=1
      elsif isSelectWindow?(cmd)
        @totalCommands['select_window']+=1
      else
        rc=false
      end

      rc
    end
  end
end
