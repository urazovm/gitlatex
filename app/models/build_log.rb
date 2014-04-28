class BuildLog < ActiveRecord::Base
  default_scope { order(:number) }
  
  belongs_to :process, class_name: BuildProcess.name

  validates :command, presence: true
end
