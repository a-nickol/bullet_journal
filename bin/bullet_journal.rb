#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bullet_journal'

def quartal(month)
  ((month - 1) / 4) + 1
end

if ARGV.empty?
  date = Date.today
  BulletJournal::CLI.new.calendar(date.year, quartal(date.month))
else
  BulletJournal::CLI.start
end
