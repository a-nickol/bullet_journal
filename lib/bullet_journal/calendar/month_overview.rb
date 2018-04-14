# frozen_string_literal: true

module BulletJournal
  ##
  # Module for printing a overview for the month.
  #
  class MonthOverview
    include DateHelper

    FONT_SIZE = 6

    def initialize(doc, date, options = {})
      @doc = doc
      @highlight = options[:highlight]
      @start_date = calc_start_date(date)
      @end_date = calc_end_date(date)
      @weeks = calc_weeks(@start_date, @end_date)
    end

    def print(x, y, width, height)
      @width = width
      @height = height

      # @doc.stroke_rectangle([x, y + height], width, height)
      @doc.translate x, y do
        print_calendar
      end
    end

    private

    def calc_start_date(date)
      Date.new(date.year, date.month, 1)
    end

    def calc_end_date(date)
      Date.new(date.year, date.month, -1)
    end

    def calc_weeks(start_date, end_date)
      weeks = 1
      week = start_date.cweek
      (start_date..end_date).each do |d|
        if week != d.cweek
          week = d.cweek
          weeks += 1
        end
      end
      weeks
    end

    def cell_width
      @width / (@weeks + 1)
    end

    def print_calendar
      print_month_name
      print_header
      (@start_date..@end_date).group_by(&:cweek).each_with_index do |week, i|
        x = i + 1
        w = week[1]
        date = w.first
        print_week_number(x, date)
        highlight_week(x) if highlight?(date)
        w.each do |day|
          print_date(x, day)
        end
      end
    end

    def print_week_number(x, date)
      @doc.formatted_text_box [{ text: date.cweek.to_s }],
                              at: [cell_width * x, @height - @height / 9 * 1],
                              width: cell_width, align: :center,
                              size: FONT_SIZE, styles: :bold
    end

    def print_date(x, date)
      y = date.wday + 1
      y = 8 if y == 1
      @doc.formatted_text_box [{ text: date.strftime('%d') }],
                              at: [cell_width * x, @height - @height / 9 * y],
                              width: cell_width,
                              align: :center,
                              size: FONT_SIZE
    end

    def print_header
      %w[KW MO DI MI DO FR SA SO].each_with_index do |s, i|
        @doc.formatted_text_box [{ text: s, styles: [:bold] }],
                                at: [0, @height - @height / 9 * (i + 1)],
                                width: cell_width,
                                align: :center,
                                size: FONT_SIZE
      end
    end

    def print_month_name
      @doc.formatted_text_box [{ text: month_name(@start_date), styles: [:bold] }],
                              at: [0, @height + 4],
                              width: @width,
                              align: :center,
                              size: FONT_SIZE + 1
    end

    def highlight_week(x)
      pos = [cell_width * x, @height - 5]
      rounded_rectangle pos, cell_width, @height - 8, 5
      stroke
    end

    def highlight?(date)
      !@highlight.nil? && (@highlight.cweek == date.cweek)
    end
  end
end
