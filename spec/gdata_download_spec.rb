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
    @rexml = REXML::Document.new( s )
    stub( 'GData_HTTP_Response', :to_xml => @rexml.root )
  end

  it 'should list documents' do
    @doc_list_client = stub( 'DocList', :clientlogin => true )
    GData::Client::DocList.stub!( :new => @doc_list_client )

    download = Gdata::Download.new( 'user', 'password' )

    @doc_list_client.       should_receive( :get ).
                            and_return( canned_doc_list_response )

    documents = download.documents

    documents.              should     == [ { :file_name => 'Doc1.odt',
                                              :url       => 'https://docs.google.com/feeds/download/documents/export/Export?id=XXXXXXXX&exportFormat=odt' },
                                            { :file_name => 'Doc2.odt',
                                              :url       => 'https://docs.google.com/feeds/download/documents/export/Export?id=YYYYYYYY&exportFormat=odt' } ]
  end

end

