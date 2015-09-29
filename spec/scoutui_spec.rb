require 'spec_helper'

describe Scoutui do

  it 'has a version number' do
    expect(Scoutui::VERSION).not_to be nil
  end

  it 'vtf should not be nil' do
    vtf=Scoutui::Base::VisualTestFramework.new()

    expect(vtf).not_to be nil
  end

  it 'qApplitools object is not nil' do
    q=Scoutui::Base::QApplitools.new()
    expect(q).not_to be nil
  end



  # it 'does something useful' do
  #   expect(false).to eq(true)
  # end
end
