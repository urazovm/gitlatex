class BuildedFileDecorator < Draper::Decorator
  decorates_association :build

  def path
    "/files/" + object.path
  end
  def name
    object.name
  end
end
