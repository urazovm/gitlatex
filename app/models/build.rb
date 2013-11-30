class Build < ActiveRecord::Base
  has_many :events, as: :eventable, dependent: :delete_all
  has_many :files, class_name: BuildedFile.name , dependent: :destroy

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
    @project = project
    p @project
  end

  def project
    Project.get(self.project_id)
  end

  def branch
    ref.split('refs/heads/')[1]
  end
end
