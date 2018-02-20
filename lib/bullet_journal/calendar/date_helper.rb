# frozen_string_literal: true

module BulletJournal
  ##
  # Contains methods for testing dates.
  #
  module DateHelper
    def rest_day?(date)
      weekend?(date) || holiday?(date)
    end

    def holiday?(date)
      Holidays.on(date, :de_he)
    end

    def weekend?(date)
      [0, 6].include?(date.wday)
    end
  end
end
