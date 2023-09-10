# frozen_string_literal: true

class ActivityManager
  def self.save_activity(activity_data)
    Activity.create(activity_data)
  end

  def self.list_activities(limit = 5)
    Activity.limit(limit).order(created_at: :desc)
  end
end
