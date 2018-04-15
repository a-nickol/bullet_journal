# frozen_string_literal: true

module BulletJournal
  ##
  # This layout is specially designed for left handed writers. The bullet journal
  # is used in "landscape mode" with a split design. There are horizontal fields on
  # the left, for each day of the week one field. On the right there are fields for
  # notetaking, future planing and motivation.
  #
  # x--------------------------x
  # |   header   |    header   |
  # |------------|-------------|
  # |   monday   |       notes |
  # |------------|             |
  # |  thuesday  |             |
  # |------------|-------------|
  # |  wednesday |high- |      |
  # |------------| light| aim  |
  # |  thursday  |-------------|
  # |------------|       future|
  # |   friday   |             |
  # x--------------------------x
  #
  class LandscapeHorizontal < Calendar
    include LayoutHelper

    HEADER_POSITION = 50

    def layout_day(date)
      indent 5 do
        feiertag = ''
        feiertag = ' Feiertag' if holiday?(date)
        formatted_text_box [{ text: (date.strftime '%d').to_s, styles: [:bold] },
                            { text: " #{wday_name(date)}", size: 8 },
                            { text: feiertag, size: 6, styles: [:italic] }]
      end

      grid 3, 4 do |x, y|
        index = (y + (2 - x) * 4)
        if @tasks[date]
          todo = @tasks[date][index]
          if todo
            stroke_circle [0, 19], 3
            indent 15 do
              text todo
            end
          end
        end
      end

      stroke_color GRAY
      stroke_horizontal_line 0, bounds.width, at: 5
    end

    def layout_left_page
      split_horizontal at: HEADER_POSITION do |split|
        split.top do
          header :left
        end
        split.bottom do
          dotted_background
          grid 1, 5 do |_, y|
            case y
            when 0
              monday
            when 1
              thuesday
            when 2
              wednesday
            when 3
              thursday
            when 4
              friday
            end
          end
        end
      end
    end

    def layout_right_page
      split_horizontal at: HEADER_POSITION do |split|
        split.top do
          header :right
        end
        split.bottom do
          layout_right_bottom
        end
      end
    end

    def layout_right_bottom
      dotted_background
      split_horizontal percent: 50 do |split|
        split.top do
          box :right, 'Notizen'
          border :bottom_left, :bottom_right
        end
        split.bottom do
          split_horizontal percent: 50 do |split|
            split.top do
              split_vertical percent: 50 do |split|
                split.left do
                  box :left, 'Ziel der Woche'
                  border :top_right, :bottom_right
                end
                split.right do
                  box :right, 'Hightlight der Woche'
                end
              end
              border :bottom_left, :bottom_right
            end
            split.bottom do
              box :right, 'Sonstige Aufgaben'
            end
          end
        end
      end
    end

    def header_text(orientation, date)
      if orientation == :left
        "#{date.year} #{month_name(date)}"
      else
        "#{month_name(date)} #{date.year}"
      end
    end

    def header(orientation)
      stroke_color GRAY
      border :bottom_left, :bottom_right

      date = @current_week[0]
      month = date
      if orientation == :left
        x = width - 100
      else
        x = 0
        month = month >> 1
      end

      month_overview(month, date, x, 0, 100, 70)

      stroke_color BLACK

      text = header_text(orientation, date)
      text_box text, at: [0, 20],
                     width: width, align: orientation,
                     style: :bold
    end
  end
end
