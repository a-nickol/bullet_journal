# frozen_string_literal: true

class Date
  include Holidays::CoreExtensions::Date

  def dayname
    %w[Sonntag Montag Dienstag Mittwoch Donnerstag Freitag][wday]
  end

  def monthname
    ['', 'Jannuar', 'Februar', "M\xC3\xA4rz", 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'][month]
  end
end
