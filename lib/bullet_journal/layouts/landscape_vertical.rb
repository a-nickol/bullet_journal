# frozen_string_literal: true

def day do
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

  stroke_color @gray
  stroke_horizontal_line 0, bounds.width, at: 5 if i != 4
end

def header do |orientation|
  stroke_color @gray
  stroke_horizontal_line 0, @width, at: @header_position

  stroke_color @black
  if orientation == :left
    text_box "#{date.year} #{date.monthname}", at: [0, @header_position + 20], width: @width, align: :left, style: :bold
  else
    text_box "#{date.monthname} #{date.year}", at: [0, @header_position + 20], width: @width, align: :right, style: :bold
  end
end

end

def box do |orientation, text|
  text_box text, at: [0, 0], heigth: heigth, width: width, align: orientation, size: 9
end

@gray = '555555'
@black = '000000'
@header_position = 100

layout do
  left do
    split_vertical header_position
      top do
        header :left
      end
      bottom do
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

  layout.right do
    split_horizontal header_position
      top do
        header :right
      end
      bottom do
        dotted_background
        split_horizontal percent: 50
          top do
            template :box, :right, 'Notizen'
            border :bottom_left, :bottom_right
          end
          bottom do
            split_horizontal percent: 50
              top do
                split_vertical percent: 50
                  left do
                    template :box, :left, 'Ziel der Woche'
                    border :top_right, :bottom_right
                  end
                  right do
                    template :box, :right, 'Hightlight der Woche'
                  end
                end
                border :bottom_left, :bottom_right
              end
              bottom do
                template :box, :right, 'Sonstige Aufgaben'
              end
            end
          end
        end
      end
    end
  end
end
