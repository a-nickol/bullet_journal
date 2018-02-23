# frozen_string_literal: true

module BulletJournal
  ##
  # Encapsulates the generation of daily, weekly and monthly tasks.
  #
  class Tasks
    include DateHelper

    def self.for(date_range)
      Tasks.new(date_range)
    end

    def initialize(date_range)
      date_range = initialize_date_range(date_range)
      initialize_tasks
      generate_tasks date_range
    end

    def [](date)
      @tasks[date]
    end

    private

    def initialize_date_range(date_range)
      date_range = date_range.sort
      add_days_at_front(date_range, 7)
    end

    def initialize_tasks
      @tasks = Hash.new { |h, k| h[k] = [] }
    end

    def add_days_at_front(date_range, days)
      days.times { date_range.unshift(date_range.first - 1) }
      date_range
    end

    def generate_tasks(date_range)
      date_range = date_range.reject { |date| rest_day?(date) }
      date_range.each_cons(2) do |last_date, date|
        generate_task last_date, date
      end
    end

    def generate_task(last_date, date)
      daily_task date
      weekly_task if week_changed last_date, date
      monthly_task if month_changed last_date, date
    end

    def week_changed(date1, date2)
      date1.cweek != date2.cweek
    end

    def month_changed(date1, date2)
      date1.month != date2.month
    end

    def daily_task(date)
      add_task(date, 'Stundenzettel')
    end

    def weekly_task(date)
      add_task(date, 'Wochenplanung')
    end

    def monthly_task(last_date, date)
      add_task(last_date, 'RPME')
      add_task(date, 'Monatsbericht')
      add_task(date, 'Monatsplanung')
      add_task(date, 'Quartalsplanung') if date.month % 3 == 1
    end

    def add_task(date, task)
      @tasks[date].push(task)
    end
  end
end
