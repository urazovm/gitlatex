require 'gitlatex'
class Build < ActiveRecord::Base
  has_many :events, as: :eventable, dependent: :delete_all
  has_many :files, class_name: BuildedFile.name , dependent: :destroy

  serialize :log

  scope :project, lambda{|id| where(project_id: id).order(updated_at: :desc)}

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
    @process = Gitlatex::Process.perform self

    self.status = @process.error.nil? ? :success : :error
    self.error = @process.error.message if @process.error
    self.log = @process.log.map do |log|
      if log.is_a?(Symbol)
        log
      else
        {command: log.command, output: log.output.encode('UTF-16', 'UTF-8', invalid: :replace, replace: '').encode('UTF-8', 'UTF-16')}
      end
    end
    @process.files.each do |file|
      self.files << BuildedFile.new(file)
    end
    self.save
  end

  def project
    Project.get(self.project_id)
  end

  def branch
    ref.split('refs/heads/')[1]
  end

  def unique_name
    "builds/build#{id}"
  end
end
