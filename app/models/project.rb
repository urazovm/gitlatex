class Project < ActiveRecord::Base
  belongs_to :owner_id, class_name: User.name
end
