#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bullet_journal'

if ARGV.empty?
  BulletJournal::CLI.new.calendar 2018, 1
else
  BulletJournal::CLI.start
end
