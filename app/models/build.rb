class Build < ActiveRecord::Base
  has_many :events, as: :eventable, dependent: :delete_all

  after_save :push_event

  def push_event
    event = Event.new
    event.eventable = self
    event.project_id = self.project_id
    event.status = self.status
    event.save
  end
  private :push_event

  def decorate(options=nil)
    @decorate ||= BuildDecorator.decorate(self)
  end

  def perform
    p self
  end

  def branch
    ref.split('refs/heads/')[1]
  end
end
