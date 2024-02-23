# frozen_string_literal: true

require 'prawn'
require 'holidays'

module BulletJournal
  ##
  # Generates printable calendar sheets for a bullet journal.
  #
  class Calendar
    include Prawn::View
    include Colors
    include DateHelper
    include LayoutHelper

    def initialize(start_date, end_date)
      initialize_pdf_document
      initialize_dates(start_date, end_date)
      @tasks = Tasks.for(start_date..end_date)
      build_pages
    end

    def build_pages
      @dates.each_slice(7) do |week|
        build_double_page(week)
      end
    end

    def build_double_page(week)
      @current_week = week
      build_left_page
      build_right_page
    end

    def build_left_page
      start_new_page if page_count > 1
      layout_left_page
    end

    def build_right_page
      start_new_page
      layout_right_page
    end

    def monday
      layout_day @current_week[0]
    end

    def thuesday
      layout_day @current_week[1]
    end

    def wednesday
      layout_day @current_week[2]
    end

    def thursday
      layout_day @current_week[3]
    end

    def friday
      layout_day @current_week[4]
    end

    def duplex_print?
      false
    end

    def month_overview(date, highlight, pos, width, height)
      m = MonthOverview.new(@document, date, highlight: highlight)
      m.print(pos, width, height)
    end

    private

    def initialize_pdf_document
      @document = Prawn::Document.new(page_layout: :portrait, page_size: 'A5')
      @page_width = bounds.width
      @page_height = bounds.height
      initialize_font
    end

    def initialize_font
      font_families.update(Fonts::FONTS)
      font 'Roboto'
      font_size 12
    end

    def initialize_dates(start_date, end_date)
      start_date -= 4 if duplex_print?
      @start_date = start_date
      @end_date = end_date
      @dates = (start_date..end_date).to_a
      ensure_fortnight
      reorder_dates_for_duplex_printing if duplex_print?
    end

    def ensure_fortnight
      add_dates = 14 - (@dates.length % 14)
      return unless add_dates.positive?
      dates = (@end_date + 1)..(@end_date + add_dates)
      @dates.push(*dates)
    end

    def reorder_dates_for_duplex_printing
      reorder_dates = []
      @dates.each_slice(14) do |slice|
        reorder_dates.push(*slice[4..-1])
        reorder_dates.push(*slice[0..3])
      end
      @dates = reorder_dates
    end
  end
end
