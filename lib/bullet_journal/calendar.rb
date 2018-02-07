# frozen_string_literal: true

require 'date'
require 'prawn'
require 'prawn/measurement_extensions'
require 'holidays'
require 'holidays/core_extensions/date'

require 'bullet_journal/month_overview'

require 'bullet_journal/ext/date'
require 'bullet_journal/prawn_extensions'

module BulletJournal
  class Calendar
    include MonthOverview
    include Grid
    include Background
    include Split
    include Prawn::View

    HEADER_POSITION = 1500
    GRAY = '666666'
    BLACK = '000000'

    def initialize; end

    public

    def calendar(start_date, end_date, layout, output)
      @start_date = start_date
      @end_date = end_date

      @document = Prawn::Document.new(page_layout: :portrait, page_size: 'A5')

      @width = bounds.bottom_right[0]
      @height = bounds.top_left[1]

      font_families.update('Roboto' => {
        normal: 'data/fonts/Roboto-Regular.ttf',
        bold: 'data/fonts/Roboto-Bold.ttf',
        italic: 'data/fonts/Roboto-Italic.ttf'
      })

      font 'Roboto'
      font_size 12

      generate_dates
      generate_reorder_dates
      generate_todos

      setup_page(true, @start_date)

      page = 0
      num = 0

      @reorder_dates.each do |date|
        next if [0, 6].include?(date.wday)

        if num % 5 == (page.even? ? 3 : 2)
          page += 1
          num = 0
          start_new_page
          setup_page(page.even?, date)
        end

        num += 1
      end
      save_as output
    end

    private

    def generate_reorder_dates
      @reorder_dates = @dates[0..13]
      @dates[14..-1].each_slice(14) do |slice|
        @reorder_dates += slice[4..-1]
        @reorder_dates += slice[0..3]
      end
    end

    def generate_dates
      @dates = (@start_date..@end_date).to_a
      @dates.insert(10, *((@start_date - 4)...@start_date)) if @dates.length > 7
      number_of_dates = 14 - (@dates.length % 14)
      @dates += ((@end_date + 1)..(@end_date + number_of_dates)).to_a
    end

    def generate_todos
      @todos = Hash.new { |h, k| h[k] = [] }
      current_month = @start_date.month
      current_week = @start_date.cweek - 1
      last_date = nil
      ((@start_date - 7)..(@end_date + 7)).each do |date|
        next if [0, 6].include?(date.wday)
        next if date.holiday?(:de_he)

        @todos[date] << 'Stundenzettel'
        @todos[date] << 'Monatsbericht' if current_month != date.month

        if current_week != date.cweek
          @todos[date] << 'Wochenplanung'
          current_week = date.cweek
        end

        if current_month != date.month
          @todos[last_date] << 'RPME'
          @todos[date] << 'Monatsplanung'
          @todos[date] << 'Quartalsplanung' if date.month % 3 == 1
          current_month = date.month
        end

        last_date = date
      end
    end

    def header(page_even, date)
      stroke_color GRAY
      stroke_horizontal_line 0, @width, at: HEADER_POSITION

      stroke_color BLACK
      if page_even
        text_box "#{date.year} #{date.monthname}", at: [0, HEADER_POSITION + 20], width: @width, align: :left, style: :bold
      else
        text_box "#{date.monthname} #{date.year}", at: [0, HEADER_POSITION + 20], width: @width, align: :right, style: :bold
      end
    end

    def setup_page(page_even, date)
      stroke_axis

      horizontal_split HEADER_POSITION do
        top do
          header page_even, date
        end
        bottom do
          dotted_background
        end
      end

      month_width = 80
      month_height = 50

      if page_even
        padding_x = 0
        padding_y = 5
        translate(@width - month_width, @height - padding_y) do
          print_month(date, date, month_width, month_height)
        end

        5.times do |i|
          current_date = date + i
          h = HEADER_POSITION / 5
          offset = i * h
          bounding_box([padding_x, HEADER_POSITION - padding_y - offset], width: @width - padding_x * 2, height: h) do
            indent 5 do
              feiertag = ''
              feiertag = ' Feiertag' if current_date.holiday?(:de_he)
              formatted_text_box [{ text: (current_date.strftime '%d').to_s, styles: [:bold] },
                                  { text: " #{current_date.dayname}", size: 8 },
                                  { text: feiertag, size: 6, styles: [:italic] }]
            end

            create_grid 3, 4 do |x, y|
              index = (y + (2 - x) * 4)
              if @todos[current_date]
                todo = @todos[current_date][index]
                if todo
                  stroke_circle [0, 19], 3
                  indent 15 do
                    text todo
                  end
                end
              end
            end

            stroke_color GRAY
            stroke_horizontal_line 0, bounds.width, at: 5 if i != 4
            # stroke_bounds
          end
        end
      else
        stroke_color GRAY
        stroke_horizontal_line 0, @width, at: @height / 2
        stroke_vertical_line @height / 4, @height / 2, at: @width / 2
        stroke_horizontal_line 0, @width, at: @height / 4

        stroke_color BLACK
        font_size = 8
        align = :right
        padding_x = 10
        padding_y = 5
        x = @width - @width / 3 - padding_x
        width = @width / 3

        text_box 'Notizen', at: [x, HEADER_POSITION - padding_y], width: width, align: align, size: font_size
        text_box 'Sonstige Aufgaben', at: [x, @height / 4 - padding_y], width: width, align: align, size: font_size

        text_box 'Ziel der Woche', at: [padding_x, @height / 2 - padding_y], width: width, align: :left, size: font_size
        text_box 'Hightlight der Woche', at: [x, @height / 2 - padding_y], width: width, align: align, size: font_size

        translate(0, @height - padding_y) do
          print_month(date >> 1, date, month_width, month_height)
        end
      end
    end
  end
end
