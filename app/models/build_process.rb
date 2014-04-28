class BuildProcess < ActiveRecord::Base
  default_scope { order(:number) }
  
  belongs_to :build
  has_many :logs, foreign_key: :process_id, class_name: BuildLog.name, dependent: :destroy

  validates :name, presence: true
end
