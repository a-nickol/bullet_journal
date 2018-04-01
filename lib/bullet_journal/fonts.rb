# frozen_string_literal: true

module BulletJournal
  module Fonts
    DIR = File.expand_path('../../../data/fonts', __FILE__)
    FONTS = {
      'Roboto' => {
        normal: "#{DIR}/Roboto-Regular.ttf",
        bold: "#{DIR}/Roboto-Bold.ttf",
        italic: "#{DIR}/Roboto-Italic.ttf"
      }
    }.freeze
  end
end
