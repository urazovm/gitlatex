class Repository
  include Gitlab

  attribute :name, String
  attribute :url, String
  attribute :description, String
  attribute :homepage, String
end
