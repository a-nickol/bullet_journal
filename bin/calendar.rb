require "thor"
require_relative "../lib/calendar.rb"

class CalendarCLI < Thor
  desc "generate YEAR QUARTER", ""
  def generate(year, quarter)
    c = Calendar.new
    c.generate(year, quarter, "calendar.pdf")
  end

  default_task :generate
end

if ARGV.empty?
  CalendarCLI.new.generate 2018, 1
else
  CalendarCLI.start
end

