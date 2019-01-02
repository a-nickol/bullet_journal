# frozen_string_literal: true

module BulletJournal
  ##
  #
  class DottedPaper
    include Prawn::View
    include LayoutHelper
    include Colors

    def initialize()
      initialize_pdf_document
      create_dots
      create_middleline
    end

    private

    def initialize_pdf_document
      @document = Prawn::Document.new(page_layout: :landscape, page_size: 'A4', margin: 0)
      @page_width = bounds.width
      @page_height = bounds.height
      initialize_font
    end

    def initialize_font
      font_families.update(Fonts::FONTS)
      font 'Roboto'
      font_size 12
    end

    def create_dots
      dotted_background
    end

    def create_middleline
      stroke_color(GRAY)
      line_width(0.5)
      dash(4, space: 10)
      stroke_vertical_line(0, height, at: width / 2)
    end
  end
end
