class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true

  scope :project, lambda{|id| where(project_id: id).order(updated_at: :desc)}
end
