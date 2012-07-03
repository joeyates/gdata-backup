require 'gdata/client'
require 'gdata/http'
require 'gdata/auth'
require 'logger'

module Gdata

  class Download

    def initialize( user, password, options = {} )
      @user, @password, @options = user, password, options.clone
      @log       = Logger.new( STDOUT )
      @log.level = Logger::INFO
    end

    def download
      raise ':path missing from options' unless @options[ :path ]
      raise ":path option indicates a non-existent directory: '#{ @options[ :path ] }'" unless File.directory?( @options[ :path ] ) 
      documents.each do | document |
        @log.info document[ :file_name ]
        begin
          response = spreadsheet_client.get( document[ :url ] )
        rescue => e
          @log.error "Download of #{ document[ :file_name ] } failed: #{ e }"
          next
        end
        File.open( @options[ :path ] + '/' + document[ :file_name ], 'wb' ) do | file |
          file.write response.body
        end
      end
    end

    def documents
      return @documents if @documents

      doc = doc_list_client.get( 'https://docs.google.com/feeds/documents/private/full' )
      list = doc.to_xml

      @documents = []
      list.elements.each( 'entry' ) do | entry |
        src    = entry.elements[ 'content' ].attributes[ 'src' ]
        title  = entry.elements[ 'title' ].text
        format = download_format( src, title )
        if format == ''
          @log.info "Skipping '#{title}'"
          next
        end
        url         = src + '&exportFormat=' + format
        clean_title = title.gsub(/[^a-z0-9\s\-\_]/i, '_')
        file_name   = clean_title + '.' + format
        @documents  << { :file_name => file_name,
                         :url       => url }
      end

      @documents
    end

    private

    def doc_list_client
      return @doc_list_client if @doc_list_client
      @doc_list_client = GData::Client::DocList.new
      @doc_list_client.clientlogin( @user, @password )
      @doc_list_client
    end

    def spreadsheet_client
      return @spreadsheet_client if @spreadsheet_client
      @spreadsheet_client = GData::Client::Spreadsheets.new
      @spreadsheet_client.clientlogin( @user, @password )
      @spreadsheet_client
    end

    def download_format( url, title )
      case
      when title =~ %r(\.pdf$)
        ''
      when url =~ %r(feeds/download/presentations)
        ''
      when url =~ /spreadsheets/
        'ods'
      else
        'odt'
      end
    end

  end

end

