# frozen_string_literal: true

require 'thor'
require_relative 'activity'
require_relative 'db_connect'
require_relative 'bored_api_wrapper'
require_relative 'activity_manager'

class Wrapper < Thor
  desc 'new', 'Get and save a new random activity'
  method_option :type,
                enum: %w[education recreational social diy charity cooking relaxation music busywork]
  method_option :participants, type: :numeric
  method_option :minaccessibility, type: :numeric, aliases: '--accessibility_min'
  method_option :maxaccessibility, type: :numeric, aliases: '--accessibility_max'
  method_option :minprice, type: :numeric, aliases: '--price_min'
  method_option :maxprice, type: :numeric, aliases: '--price_max'

  def new
    validate
    activity_data = BoredApiWrapper.random_activity(options)

    if activity_data
      puts 'Your random activity:'
      puts ''
      activity_data.each do |key, value|
        puts "#{key}: #{value}"
      end

      ActivityManager.save_activity(activity_data)
      puts ''
      puts 'Your random activity has saved in database'
    else
      puts ''
      puts 'No activity saved'
    end
  end

  desc 'list', 'List the latest activities'

  def list
    puts 'Your last 5 activities:'
    puts ''
    activities = ActivityManager.list_activities
    activities.each do |activity|
      puts "activity: #{activity.activity}"
      puts "type: #{activity.type}"
      puts "participants: #{activity.participants}"
      puts "price: #{activity.price}"
      puts "link: #{activity.link}"
      puts "key: #{activity.key}"
      puts "accessibility: #{activity.accessibility}"
      puts ''
    end
    # activities.each { |activity| puts activity.activity }
  end

  def self.exit_on_failure?
    true
  end

  private

  def validate
    validate_participants(options[:participants])
    validate_range(options[:minaccessibility], 0.0, 1.0,
                   'Minimum accessibility is out of range (0.0..1.0)')
    validate_range(options[:maxaccessibility], 0.0, 1.0,
                   'Maximum accessibility is out of range (0.0..1.0)')
    validate_range(options[:minprice], 0.0, 1.0, 'Minimum price is out of range (0..1)')
    validate_range(options[:maxprice], 0.0, 1.0, 'Maximum price is out of range (0..1)')
  end

  def validate_participants(participants)
    return unless participants && participants.to_i <= 0

    puts 'Number of participants must be greater than 0'
  end

  def validate_range(value, min, max, error_message)
    return unless value && (value < min || value > max)

    puts error_message
  end
end

Wrapper.start
