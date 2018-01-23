module MonthOverview
  def print_month(date, highlight_week, width, height)
    start_date = Date.new(date.year, date.month, 1)
    end_date = Date.new(date.year, date.month, -1)

    weeks = 1
    week = start_date.cweek
    (start_date..end_date).each do |d|
      if week != d.cweek
        week = d.cweek
        weeks = weeks + 1
      end
    end

    size = 6

    cell_width = width / (weeks  + 1)

    translate 0, -20 do

      formatted_text_box [ { text: "#{date.monthname}", styles: [:bold] } ], :at => [0, height + 4], :width => width, :align => :center, size: size + 1

      ["KW", "MO", "DI", "MI", "DO", "FR", "SA", "SO"].each_with_index do |s, i|
        formatted_text_box [ { text: s, styles: [:bold] }
        ], :at => [0, height - height / 9 * (i + 1)], :width => cell_width, :align => :center, size: size
      end

      x = 1
      week = start_date.cweek
      (start_date..end_date).each do |d|
        if week != d.cweek
          week = d.cweek
          x = x + 1
        end
        y = d.wday
        if y == 0
          y = 7
        end
        y += 1
        if highlight_week.cweek == d.cweek
          line_width = 0.5
          rounded_rectangle [cell_width * x, height - 5], cell_width, height - 8, 5
          stroke
        end
        formatted_text_box [ { text: d.cweek.to_s }
        ], :at => [cell_width * x, height - height / 9 * 1], :width => cell_width, :align => :center, size: size, styles: :bold
        formatted_text_box [ { text: d.strftime('%d') }
        ], :at => [cell_width * x, height - height / 9 * y], :width => cell_width, :align => :center, size: size
      end
    end
  end
end
