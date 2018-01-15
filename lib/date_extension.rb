class Date
  include Holidays::CoreExtensions::Date

  def dayname
    ["Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag"][self.wday]
  end

  def monthname
    ["", "Jannuar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"][self.month]
  end
end

