require "prawn"
require "date"
require 'pry-byebug'
require 'holidays'
require 'holidays/core_extensions/date'
require_relative "date_extension.rb"
require_relative "month_overview.rb"

$lower_part = 40
$upper_part = 50
$padding_row = 12
$number_of_horizontal_lines = 12

class Calender
  include MonthOverview
  include Prawn::View

  def initialize
  end

  def generate_reorder_dates
    @reorder_dates = @dates[0..13]
    @dates[14..-1].each_slice(14) do |slice|
      @reorder_dates = @reorder_dates + slice[4..-1]
      @reorder_dates = @reorder_dates + slice[0..3]
    end
  end

  def generate_dates
    @dates = (@start_date..@end_date).to_a
    if @dates.length > 7
      @dates.insert(10, *((@start_date - 4)...@start_date))
    end
    number_of_dates = 14 - (@dates.length % 14)
    @dates = @dates + ((@end_date + 1)..(@end_date + number_of_dates)).to_a
  end

  def generate_todos
    @todos = Hash.new {|h,k| h[k] = [] }
    current_month = @start_date.month
    current_week = @start_date.cweek - 1
    last_date = nil
    ((@start_date - 7)..(@end_date + 7)).each do |date|
      if [0, 6].include?(date.wday)
        next
      end
      if date.holiday?(:de_he)
        next
      end

      @todos[date] << "Stundenzettel"
      if current_month != date.month
        @todos[date] << "Monatsbericht"
      end

      if current_week != date.cweek
        @todos[date] << "Wochenplanung"
        current_week = date.cweek
      end

      if current_month != date.month
        @todos[last_date] << "RPME"
        @todos[date] << "Monatsplanung"
        if date.month % 3 == 1
          @todos[date] << "Quartalsplanung"
        end
        current_month = date.month
      end

      last_date = date
    end
  end

  def generate year, quarter, output
    start_year = Date.new(year, ((quarter - 1) * 3) + 1, 1).cwyear
    start_week = Date.new(year, ((quarter - 1) * 3) + 1, 1).cweek

    end_year = Date.new(year, quarter * 3, -1).cwyear
    end_week = Date.new(year, quarter * 3, -1).cweek

    @start_date = Date.commercial(start_year, start_week, 1)
    @end_date = Date.commercial(end_year, end_week, 5)

    @document = Prawn::Document.new(page_layout: :portrait, page_size: "A5")

    font_families.update("Roboto" => {
      :normal => 'fonts/Roboto-Regular.ttf',
      :bold => 'fonts/Roboto-Bold.ttf',
      :italic => 'fonts/Roboto-Italic.ttf'
    })

    font "Roboto"
    font_size 12

    width = bounds.bottom_right[0]
    height = bounds.top_left[1]

    new_page(false, true, @start_date)

    page = 0
    num = 0
    next_page = false

    generate_todos
    generate_dates
    generate_reorder_dates

    @reorder_dates.each do |date|
      if [0, 6].include?(date.wday)
        next
      end

      if num % 5 == (page % 2 == 0 ? 3 : 2)
        page = page + 1
        num = 0
        new_page(true, page % 2 == 0, date)
      end

      translate(num * width / 3, 465) do
        feiertag = ""
        if date.holiday?(:de_he)
          feiertag = " Feiertag"
        end
        formatted_text_box [ { text: "#{date.strftime'%d'}", styles: [:bold] },
                             { text: " #{date.dayname}", size: 8 },
                             { text: feiertag, size: 6, styles: [:italic] }
        ], :at => [6, 30], :width => width / 3, :align => :left
      end

      if @todos[date]
        @todos[date].each_with_index do |todo, i|
          start_y = $lower_part
          height_y = height - start_y - $upper_part
          translate(num * width / 3 + 20, start_y + i * height_y / $number_of_horizontal_lines - 6 ) do
            stroke_circle [0, 24], 3
            formatted_text_box [ { text: todo },
            ], :at => [6, 30], :width => width / 3, :align => :left, :size => 10
          end
        end
      end

      num = num + 1
    end

    save_as output
  end

  def new_page(new_page, page_even, date)
    width = bounds.bottom_right[0]
    height = bounds.top_left[1]

    if new_page
      start_new_page
    end

    # stroke_axis
    stroke_color '999999'
    stroke do
      horizontal_line 0, width, :at => 505
      horizontal_line 0, width, :at => $lower_part
      (0..(page_even ? 2 : 1)).each do |i|
        (0..$number_of_horizontal_lines).each do |j|
          start_x = i * width / 3
          start_y = $lower_part
          height_y = height - start_y - $upper_part
          horizontal_line start_x + $padding_row / 2, start_x + (width / 3) - $padding_row, :at => start_y + j * height_y / $number_of_horizontal_lines
        end
      end
    end
    stroke_color '000000'
    if (page_even)
      text_box "#{date.year.to_s} #{date.monthname}", :at => bounds.top_left, :width => width, :align => :left, :style => :bold
      text_box "KW #{date.cweek}", :at => [width - width / 3, height], :width => width / 3, :align => :right
      text_box "Hightlight der Woche", :at => [10, $lower_part - 5], :width => width / 3, :align => :left, size: 8
    else
      text_box "#{(date).monthname} #{(date).year.to_s}", :at => bounds.top_left, :width => width, :align => :right, :style => :bold
      text_box "Notizen", :at => [width - width / 3 - 10, 500], :width => width / 3, :align => :right, size: 8
      text_box "Sonstige Aufgaben", :at => [width - width / 3 - 10, $lower_part - 5], :width => width / 3, :align => :right, size: 8
      text_box "Ziel der Woche", :at => [width - width / 3 - 10, 260], :width => width / 3, :align => :right, size: 8

      print_month(date, 0, 120, date)
      print_month(date >> 1, 0, 50, date)
    end
  end
end

