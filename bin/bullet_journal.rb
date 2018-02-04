#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'
require 'bullet_journal'

module BulletJournal
  class BulletJournalCLI < Thor
    desc 'calendar YEAR QUARTER', 'creates a printable bullet journal calendar'
    def calendar(year, quarter, layout = :landscape_vertical, filename = 'calendar.pdf')
      c = BulletJournal.new

      start_year = Date.new(year, ((quarter - 1) * 3) + 1, 1).cwyear
      start_week = Date.new(year, ((quarter - 1) * 3) + 1, 1).cweek

      end_year = Date.new(year, quarter * 3, -1).cwyear
      end_week = Date.new(year, quarter * 3, -1).cweek

      start_date = Date.commercial(start_year, start_week, 1)
      end_date = Date.commercial(end_year, end_week, 5)

      c.calendar(start_date, end_date, layout, filename)
    end

    default_task :calendar
  end

  if ARGV.empty?
    BulletJournalCLI.new.calendar 2018, 1
  else
    BulletJournalCLI.start
  end
end
