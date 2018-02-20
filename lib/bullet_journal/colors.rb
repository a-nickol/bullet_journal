# frozen_string_literal: true

require 'yaml'

module BulletJournal
  ##
  # Contains all known html colors.
  #
  module Colors
    DIR = File.expand_path('../../../data/colors', __FILE__)

    def self.define_colors(file)
      colors_dict = YAML.load_file file
      colors_dict.each_value do |colors|
        colors.each do |name, color|
          Colors.const_set(name, color)
        end
      end
    end

    define_colors(File.join(DIR, 'colors.yml'))
  end
end
