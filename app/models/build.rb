class Build < ActiveRecord::Base
  has_many :events, as: :eventable, dependent: :delete_all

  after_save :push_event

  def push_event
    event = Event.new
    event.eventable = self
    event.user_id = self.
    event.status = self.status
    event.save
  end
  private :push_event

  def perform
    p self
  end
end
