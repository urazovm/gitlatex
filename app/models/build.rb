require 'gitlatex'
class Build < ActiveRecord::Base

  belongs_to :project

  has_many :process, class_name: BuildProcess.name, dependent: :destroy
  has_many :files, class_name: BuildedFile.name , dependent: :destroy

  scope :project, lambda{|id| where(project_id: id).order(updated_at: :desc)}

  def perform
    build = Gitlatex::Build.new self
    build.perform

    self.status = build.status
    self.error = process.error.try(:message)
    build.processes.each_with_index do |process, index|
      self.process << BuildProcess.new do |p|
        p.number = index
        p.name = process.name
        process.commands.each_with_index do |command, index|
          p.logs << BuildLog.new do |l|
            l.number = index
            l.command = command.command
            l.log = command.log.scrub('?')
          end
        end
      end
    end
    build.files.each do |file|
      self.files << BuildedFile.new do |f|
        f.name = f.name
        f.path = f.path
      end
    end
    self.save
  end

  def unique_name
    "builds/build#{id}"
  end
end
