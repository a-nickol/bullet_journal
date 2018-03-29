# frozen_string_literal: true

module BulletJournal
  ##
  # This layout is specially designed for left handed writers. The bullet journal
  # is used in "landscape mode" with a split design. There are vertical fields on
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
  class LandscapeVertical < Calendar
    include LayoutHelper

    HEADER_POSITION = 100

    def day
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
    end

    def header(orientation)
      stroke_color GRAY
      stroke_horizontal_line 0, width, at: HEADER_POSITION

      date = @current_week[0]

      stroke_color BLACK
      if orientation == :left
        text_box "#{date.year} #{month_name(date)}", at: [0, HEADER_POSITION + 20],
          width: width, align: :left,
          style: :bold
      else
        text_box "#{month_name(date)} #{date.year}", at: [0, HEADER_POSITION + 20],
          width: width, align: :right,
          style: :bold
      end
    end

    def box(orientation, text)
      font_size 9
      text_box text, at: [0, 0], width: width, heigth: height, align: orientation
    end

    def border(from, to)
      stroke_line bounds.send(from), bounds.send(to)
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
              split_vertical percent: 50
              left do
                box :left, 'Ziel der Woche'
                border :top_right, :bottom_right
              end
              right do
                box :right, 'Hightlight der Woche'
              end
            end
            border :bottom_left, :bottom_right
          end
        end
        split.bottom do
          box :right, 'Sonstige Aufgaben'
        end
      end
    end
  end
end
