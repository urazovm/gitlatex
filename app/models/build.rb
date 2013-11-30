require 'gitlatex'
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
    @process = Gitlatex::Process.perform self

    self.status = @process.error.nil? ? :success : :error
    self.log = ''
    @process.log.each do |log|
      if log.is_a?(Symbol)
        self.log << I18n.t("builds.build.log.process", command: log.to_s)
      else
        self.log << log.command
        self.log << "\n"
        self.log << log.output
        self.log << "\n"
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
