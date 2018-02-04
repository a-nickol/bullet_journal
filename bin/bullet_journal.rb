#!/usr/bin/env ruby
# frozen_string_literal: true

require 'thor'
require 'bullet_journal'

module BulletJournal
  class BulletJournalCLI < Thor
    desc 'calendar YEAR QUARTER', 'creates a printable bullet journal calendar'
    def calendar(year, quarter)
      c = BulletJournal.new
      c.calendar(year, quarter, 'calendar.pdf')
    end

    default_task :calendar
  end

  if ARGV.empty?
    BulletJournalCLI.new.calendar 2018, 1
  else
    BulletJournalCLI.start
  end
end
