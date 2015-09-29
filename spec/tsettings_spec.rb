require 'rspec'


describe 'Manage test settings' do


  let(:static_loc_file) { "#{File.dirname(__FILE__)}/fixtures/static_test_localization.json" }
  let(:qAcc) { Scoutui::Base::QAccounts.new(static_loc_file)  }

  let(:static_file) { "#{File.dirname(__FILE__)}/fixtures/static_test_accounts.yaml" }
  let(:qAcc) { Scoutui::Base::QAccounts.new(static_file)  }
  let(:userRecord) { qAcc.getUserRecord('administrator') }

  let(:static_settings_file) { "#{File.dirname(__FILE__)}/fixtures/static_test_settings.json" }

  it 'should manage config with JSON object' do
    opts={ :but => :firefox, :eut => :qa, :lang => 'en-us', :user => userRecord, :url => 'http://www.elvis-presley.com' }

    t=Scoutui::Base::TestSettings.new(opts)
    t.enableEyes(true)

    jFile = File.read(static_settings_file)
    jsonData=JSON.parse(jFile)

    puts "jsonData type is #{jsonData.class.to_s}"

    t.setConfig(jsonData)

    expect(t).not_to be nil
  end

  it 'should manage config with passed test settings file' do
    opts={ }

    t=Scoutui::Base::TestSettings.new(opts)
    t.enableEyes(true)


    t.setConfig(static_settings_file)
    dut=t.getScout()


    expect(t).not_to be nil
    expect(dut).to eq "/Users/pkim/h20dragon/scoutui/spec/fixtures/static_test_vtf.yml"

  end

end