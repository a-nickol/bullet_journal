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
      initialize_date_range(date_range)
      initialize_tasks
      generate_tasks
    end

    def [](date)
      @tasks[date]
    end

    private

    attr_reader :current_date
    attr_reader :last_date

    def initialize_date_range(date_range)
      @date_range = date_range.sort
      add_days_at_front(7)
    end

    def initialize_tasks
      @tasks = Hash.new { |h, k| h[k] = [] }
    end

    def add_days_at_front(days)
      days.times { @date_range.unshift(@date_range.first - 1) }
    end

    def generate_tasks
      @date_range.each do |date|
        next if rest_day?(date)
        @current_date = date
        generate_task unless @last_date.nil?
        @last_date = date
      end
    end

    def generate_task
      daily_task
      weekly_task if week_changed
      monthly_task if month_changed
    end

    def last_week
      @last_date.cweek
    end

    def last_month
      @last_date.month
    end

    def current_week
      @current_date.cweek
    end

    def current_month
      @current_date.month
    end

    def week_changed
      current_week != last_week
    end

    def month_changed
      current_month != last_month
    end

    def daily_task
      add_task('Stundenzettel')
    end

    def weekly_task
      add_task('Wochenplanung')
    end

    def monthly_task
      add_task_for_previous_day 'RPME'
      add_task 'Monatsbericht'
      add_task 'Monatsplanung'
      add_task 'Quartalsplanung' if @current_date.month % 3 == 1
    end

    def add_task(task)
      @tasks[@current_date].push(task)
    end

    def add_task_for_previous_day(task)
      @tasks[@last_date].push(task)
    end
  end
end
