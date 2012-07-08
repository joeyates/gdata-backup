# encoding: utf-8
$: << '../lib'

require 'rspec'
require 'gdata/config'

describe Gdata::Config do

  before :each do
    @data  = {}
    @store = stub('Imap::Backup::Configuration::Store', :data => @data)
  end

  context '#initialize' do
    it 'loads configuration' do
      Imap::Backup::Configuration::Store.should_receive(:new).and_return(@store)

      Gdata::Config.new
    end
  end

  context '#attributes' do
    before :each do
      Imap::Backup::Configuration::Store.stub(:new).and_return(@store)
    end

    subject { Gdata::Config.new }

    it 'has data' do
      subject.data.should == @data
    end
  end

end

