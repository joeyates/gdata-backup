# encoding: utf-8
require 'highline'

module Gdata
  class Config

      class << self
        attr_accessor :highline
      end
      self.highline = HighLine.new

  end
end

