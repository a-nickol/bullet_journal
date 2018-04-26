# frozen_string_literal: true

module BulletJournal
  ##
  # Contains methods for testing dates.
  #
  module DateHelper
    MONTH_NAMES = %w[Jannuar Februar März April Mai Juni Juli
                     August September Oktober November Dezember].freeze

    WDAY_NAMES = %w[Sonntag Montag Dienstag Mittwoch Donnerstag Freitag].freeze

    HOLIDAYS = :de_he

    def rest_day?(date)
      weekend?(date) || holiday?(date)
    end

    def holiday?(date)
      Holidays.on(date, HOLIDAYS)
    end

    def weekend?(date)
      [0, 6].include?(date.wday)
    end

    def month_name(date)
      MONTH_NAMES[date.month - 1]
    end

    def wday_name(date)
      WDAY_NAMES[date.wday]
    end

    def first_day_of_month(date)
      Date.new(date.year, date.month, 1)
    end

    def last_day_of_month(date)
      Date.new(date.year, date.month, -1)
    end
  end
end
