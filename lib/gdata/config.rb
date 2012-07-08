# encoding: utf-8
require 'imap/backup'

module Gdata
  class Config

    attr_reader :data

    def initialize
      store = Imap::Backup::Configuration::Store.new(true)
      @data = store.data
    end

  end
end

