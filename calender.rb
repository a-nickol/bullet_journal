require "thor"
require_relative "lib/calender.rb"

class CalenderCLI < Thor
  desc "generate YEAR QUARTER", ""
  def generate(year, quarter)
    c = Calender.new
    c.generate(year, quarter, "calender.pdf")
  end

  default_task :generate
end

if ARGV.empty?
  CalenderCLI.new.generate 2018, 1
else
  CalenderCLI.start
end

