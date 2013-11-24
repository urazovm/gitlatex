class Namespace
  include Gitlab

  attribute :id, Integer
  attribute :owner_id, Integer
  attribute :description, String
  attribute :name, String
  attribute :path, String
  attribute :created_at, DateTime
  attribute :updated_at, DateTime
end
