require_relative 'version'
require 'rubygems'
require 'csv'
require 'json'
require 'date'
require_relative 'manager'
require_relative 'printable'


module Boxing
  module Kata
    include Printable
    def self.report
      unless has_input_file?
        puts 'Usage: ruby ./bin/boxing-kata <spec/fixtures/family_preferences.csv'
      end
    end
    def self.has_input_file?
      !STDIN.tty?
    end
  end
end
