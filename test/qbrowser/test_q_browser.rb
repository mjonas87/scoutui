require_relative('../../lib/scoutui')
require_relative('../../lib/scoutui/base/q_browser')

puts "Start"



def ex2(strategy)
  cmdList=[]

  cmdList << {:command => 'navigate(http://www.concursolutions.com)', :e => nil }
  cmdList << {:command => 'pause', :e => nil }
  cmdList << {:command => 'verifyelement(page(login).get(login_form).get(lang))', :e => nil }
  cmdList << {:command => 'pause', :e => nil }
  cmdList << {:command => 'click(#selectLang)', :e => nil }
#  cmdList << {:command => 'pause', :e => nil }
  cmdList << {:command => 'navigate(http://www.google.com)', :e => nil }
  cmdList << {:command => 'pause', :e => nil }

  strategy.processActions(cmdList)
end

def ex1()
  strategy.navigate("http://www.concursolutions.com")

  locator="css=select"
  locator="css=[id=selectLang]"
  locator="#selectLang"
  strategy.processAction("click(#{locator})")
  strategy.processAction("pause", nil)
end


def test_confirm_js(strategy)
  cmdList=[]

  cmdList << {:command => 'navigate(http://localhost:8081/qa/confirm_js.html)', :e => nil }
  cmdList << {:command => 'pause', :e => nil }
  cmdList << {:command => 'click(#tryit)', :e => nil }
  cmdList << {:command => 'pause', :e => nil }
  cmdList << {:command => 'existsJsAlert(Press a button)', :e => nil }
  cmdList << {:command => 'pause', :e => nil }
  cmdList << {:command => 'getalert(dismiss)', :e => nil }
  cmdList << {:command => 'pause', :e => nil }
  strategy.processActions(cmdList)
end

Scoutui::Utils::TestUtils.instance.setDebug(true)

f = '../gateway/page_model.gat.json'

strategy = Scoutui::Actions::Strategy.new()
if strategy.loadModel(f)
#  ex2(strategy)
  test_confirm_js(strategy)
end

strategy.quit()

strategy.report()

