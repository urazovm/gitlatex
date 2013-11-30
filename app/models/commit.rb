class Commit
  include Gitlab

  attribute :id, String
  attribute :message, String
  attribute :timestamp, DateTime
  attribute :url, String
  attribute :author, Author
end
