class Hook
  include Gitlab

  attribute :id, Integer
  attribute :url, String
  attribute :created_at, DateTime
end
