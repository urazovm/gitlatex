class Event < ActiveRecord::Base
  belongs_to :eventable, polymorphic: true

  scope :project, lambda{|id| where(project_id: id).includes(:eventable).order(updated_at: :desc)}

  def decorate(options=nil)
    @decorate ||= EventDecorator.decorate(self,options)
  end
end
