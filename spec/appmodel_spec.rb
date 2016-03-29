require 'rspec'
require 'json'
require_relative '../lib/scoutui'

describe 'Manage JSON app-model' do

  let(:static_file1) { "#{File.dirname(__FILE__)}/fixtures/carmax.app_model.json" }


  let(:qAcc) { Scoutui::Base::QAccounts.new(static_file)  }

  let(:appModel) { Scoutui::ApplicationModel::QModel.new(static_file1) }


  before do
    puts '-- before --'


  end

  after do
    puts '-- After --'
  end


  it 'should itemize based on condition visible_when - with action hover' do

    _pg = appModel.getPageElement('page(home).get(cars4sale)')

    triggers=appModel.itemize('visible_when', 'hover', 'page(home).get(cars4sale)')

    puts __FILE__ + (__LINE__).to_s + " triggers => #{triggers}"
#    expect(triggers).to be_a_kind_of(Array)
    expect(triggers).to match_array(["page(home).get(hoverhit00)"])
  end


  it 'should itemize based on condition visible_when - with action title' do

    triggers=appModel.itemize('visible_when', 'title', 'Car[mM]ax.*online')

    puts __FILE__ + (__LINE__).to_s + " triggers => #{triggers}"
#    expect(triggers).to be_a_kind_of(Array)
    expect(triggers).to match_array(["page(home).get(register)"])
  end

  it 'should itemize based on condition click' do


    triggers=appModel.itemize("visible_when", 'click', 'page(research).get(fuel_economy)')
    puts __FILE__ + (__LINE__).to_s + " triggers => #{triggers}"
    expect(triggers).to match_array(["page(home).get(logoff)"])
  end




  it 'should itemize with multiple results' do
    triggers = appModel.itemize('visible_when', 'hover', 'page(home).get(elvis)')

    puts __FILE__ + (__LINE__).to_s + " triggers => #{triggers}"

    expect(triggers).to be_nil
  end

end
