$: << '../lib'

require 'gdata/download'
require "rexml/document"

describe Gdata::Download do
  
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
      @data = {:accounts => [{:username => 'account_username'}]}
      @config.stub!(:data).and_return(@data)
    end

    it 'should load config' do
      Imap::Backup::Configuration::Store.should_receive(:new).and_return(@config)
      @config.should_receive(:data).and_return(@data)

      Gdata::Download.new('account_username', '/a/path')
    end

    it 'should fail if the account is not configured' do
      expect do
        Gdata::Download.new('unknown_username', '/a/path')
      end.to raise_error(/unknown/)
    end

  end

  context '#documents' do

    before :each do
      @data = {:accounts => [{:username => 'jdoe@example.com', :password => 'secret'}]}
      @config = stub('Imap::Backup::Configuration::Store', :data => @data)
      Imap::Backup::Configuration::Store.stub!(:new).and_return(@config)
      @doc_list_client = stub('GData::Client::DocList')
      @doc_list_client.stub!(:clientlogin => true)
      GData::Client::DocList.stub!(:new => @doc_list_client)
      @doc_list_client.stub!(:get).
                       with('https://docs.google.com/feeds/documents/private/full').
                       and_return(canned_doc_list_response)
    end

    subject { Gdata::Download.new('jdoe@example.com', '/a/path') }

    it 'should log in' do
      @doc_list_client.           should_receive(:clientlogin).
                                  with('jdoe@example.com', 'secret').
                                  and_return(true)

      subject.documents
    end

    it 'should list documents' do
      @doc_list_client.           should_receive(:get).
                                  and_return(canned_doc_list_response)

      subject.documents
    end

    it 'should return document information' do
      documents = subject.documents

      documents.                  should == [{:file_name => 'Doc1.odt',
                                              :url       => 'https://docs.google.com/feeds/download/documents/export/Export?id=XXXXXXXX&exportFormat=odt'},
                                             {:file_name => 'Doc2.odt',
                                              :url       => 'https://docs.google.com/feeds/download/documents/export/Export?id=YYYYYYYY&exportFormat=odt'}]
    end

  end

end

