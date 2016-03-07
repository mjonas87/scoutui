require 'rspec'


describe 'Manage qforms' do


  let(:static_loc_file) { "#{File.dirname(__FILE__)}/fixtures/static_test_localization.json" }
  let(:qAcc) { Scoutui::Base::QAccounts.new(static_loc_file)  }

  let(:static_file) { "#{File.dirname(__FILE__)}/fixtures/static_test_accounts.yaml" }
  let(:qAcc) { Scoutui::Base::QAccounts.new(static_file)  }
  let(:userRecord) { qAcc.getUserRecord('administrator') }

  let(:static_settings_file) { "#{File.dirname(__FILE__)}/fixtures/static_login_page.json" }

  it 'should manage page object form' do

    model = Scoutui::Utils::TestUtils.instance.loadModel([static_settings_file])


    loginForm = Scoutui::Utils::TestUtils.instance.getPageElement('page(login).get(login_form)')

    _f = Scoutui::Utils::TestUtils.instance.getForm('page(login).get(login_form)')

    expect(_f.instance_of?(Scoutui::Base::QForm))

    puts "login_form => " + loginForm.to_json

    dut = JSON.parse('{ "userid": "peter", "password": "elvis"  }')

    puts "DUT => #{dut}"

    _f.fillForm(nil, dut)



  end



end