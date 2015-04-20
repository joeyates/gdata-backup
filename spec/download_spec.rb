$: << '../lib'

require 'gdata/backup'
require "rexml/document"

describe Gdata::Backup do
  
  def canned_doc_list_response
    s = <<EOT
<feed xmlns='http://www.w3.org/2005/Atom'>
  <entry>
     <title>Doc1</title>
     <content src='https://docs.google.com/feeds/download/documents/export/Export?id=XXXXXXXX' type='text/html'/>
  </entry>
  <entry>
     <title>Doc2</title>
     <content src='https://docs.google.com/feeds/download/documents/export/Export?id=YYYYYYYY' type='text/html'/>
  </entry>
</feed>
EOT
    @rexml = REXML::Document.new(s)
    stub('GData_HTTP_Response', :to_xml => @rexml.root)
  end

  context '#initialize' do
    before :each do
      @config = stub('Imap::Backup::Configuration::Store')
      Imap::Backup::Configuration::Store.stub!(:new).and_return(@config)
      @accounts = [{:username => 'account_username'}]
      @config.stub!(:accounts).and_return(@accounts)
    end

    it 'should fail if the account is not configured' do
      expect do
        described_class.new('unknown_username', '/a/path')
      end.to raise_error(/unknown/)
    end

  end

  context '#run' do
    let(:path) { "/a/path" }

    before :each do
      @accounts = [{:username => 'jdoe@example.com', :password => 'secret'}]
      @config = stub('Imap::Backup::Configuration::Store', :accounts => @accounts)
      Imap::Backup::Configuration::Store.stub!(:new).and_return(@config)
      @doc_list_client = stub('GData::Client::DocList')
      @doc_list_client.stub!(:clientlogin => true)
      GData::Client::DocList.stub!(:new => @doc_list_client)
      @doc_list_client.stub!(:get).
                       with('https://docs.google.com/feeds/documents/private/full').
                       and_return(canned_doc_list_response)
      allow(File).to receive(:directory?).and_call_original
      allow(File).to receive(:directory?).with(path) { true }
    end

    subject { described_class.new('jdoe@example.com', path) }

    it 'should log in' do
      @doc_list_client.           should_receive(:clientlogin).
                                  with('jdoe@example.com', 'secret').
                                  and_return(true)

      subject.run
    end

    it 'should list documents' do
      @doc_list_client.           should_receive(:get).
                                  and_return(canned_doc_list_response)

      subject.run
    end
  end

end

