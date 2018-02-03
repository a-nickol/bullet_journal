header_position = 100

define_templates do |define|
  define.day do |day|
    indent 5 do
      feiertag = ""
      if current_date.holiday?(:de_he)
        feiertag = " Feiertag"
      end
      formatted_text_box [ { text: "#{current_date.strftime'%d'}", styles: [:bold] },
                           { text: " #{current_date.dayname}", size: 8 },
                           { text: feiertag, size: 6, styles: [:italic] } ]
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

    stroke_color $gray
    stroke_horizontal_line 0, bounds.width, :at => 5 if i != 4
  end

  define.header do |orientation|
    stroke_color $gray
    stroke_horizontal_line 0, @width, :at => $header_position

    stroke_color $black
    if (orientation == :left)
      text_box "#{date.year.to_s} #{date.monthname}", :at => [0, $header_position + 20], :width => @width, :align => :left, :style => :bold
    else
      text_box "#{(date).monthname} #{(date).year.to_s}", :at => [0, $header_position + 20], :width => @width, :align => :right, :style => :bold
    end
  end

  define.box do |orientation, text|
    text_box text, :at => [0, 0] , :heigth => heigth, :width => width , :align => orientation, size: 9
  end
end

layout do |layout|
  layout.left do
    split_vertical header_position do |s|
      s.top do
        header :left
      end
      s.bottom do
        dotted_background
        grid 1, 5 do |x, y|
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
    split_horizontal header_position do |s|
      s.top do
        header :right
      end
      s.bottom do
        dotted_background
        split_horizontal percent: 50 do |s|
          s.top do
            template :box, :right, "Notizen"
            border :bottom_left, :bottom_right
          end
          s.bottom do
            split_horizontal percent: 50 do |s|
              s.top do
                split_vertical percent: 50 do |s|
                  s.left do
                    template :box, :left, "Ziel der Woche"
                    border :top_right, :bottom_right
                  end
                  s.right do
                    template :box, :right, "Hightlight der Woche"
                  end
                end
                border :bottom_left, :bottom_right
              end
              s.bottom do
                template :box, :right, "Sonstige Aufgaben"
              end
            end
          end
        end
      end
    end
  end
end
