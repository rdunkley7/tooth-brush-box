require 'boxing/kata/version'
require 'csv'
require 'json'
require 'build_box'

module Boxing
  module Kata

    def self.report
      puts 'Usage: ruby ./bin/boxing-kata spec/fixtures/family_preferences.csv' unless input_file?
      # Starting point for your code...
      file = "spec/fixtures/family_preferences.csv"
      hashed_data = read_csv_file(file)
      if hashed_data
        box = BuildBox.new(hashed_data)
        box.count_brush_colors
        box.build_starter_box
        box.build_refill_box
      end
    end

    def self.input_file?
      return false unless ARGV[0]

      File.exist?(ARGV[0])
    end

    def self.read_csv_file(file)
      if File.exist?(file)
        data = CSV.parse(File.read(file), encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all)
        data.map { |d| d.to_hash }
      else
        puts 'File not found'
      end
    end
  end
end
