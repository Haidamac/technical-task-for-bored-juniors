# frozen_string_literal: true

require 'active_record'

class Activity < ActiveRecord::Base
  self.inheritance_column = :activity_type
end
