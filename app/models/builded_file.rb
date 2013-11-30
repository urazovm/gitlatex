class BuildedFile < ActiveRecord::Base
  belongs_to :build

  def decorate(options=nil)
    @decorate ||= BuildedFileDecorator.decorate(self)
  end
end
