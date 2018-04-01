# frozen_string_literal: true

require 'thor'
require 'date'

module BulletJournal
  ##
  # Commandline interface for the bullet_journal.
  #
  class CLI < Thor
    desc 'calendar YEAR QUARTER', 'creates a printable bullet journal calendar'
    def calendar(year, quarter, options = {})
      layout = options[:layout] || :landscape_vertical
      filename = options[:filename] || 'calendar.pdf'

      (start_date, end_date) = calculate_interval year, quarter

      calendar_class = get_calendar_class(layout)
      calendar = calendar_class.new(start_date, end_date)
      calendar.save_as(filename)
    end

    default_task :calendar

    private

    def calculate_interval(year, quarter)
      start_date = Date.new(year, ((quarter - 1) * 3) + 1, 1)
      start_year = start_date.cwyear
      start_week = start_date.cweek

      end_date = Date.new(year, quarter * 3, -1)
      end_year = end_date.cwyear
      end_week = end_date.cweek

      start_date = Date.commercial(start_year, start_week, 1)
      end_date = Date.commercial(end_year, end_week, 5)

      [start_date, end_date]
    end

    def get_calendar_class(layout)
      layout_name = layout.to_s.split('_').collect(&:capitalize).join
      Object.const_get("BulletJournal::#{layout_name}")
    end
  end
end
