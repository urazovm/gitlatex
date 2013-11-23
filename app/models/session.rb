class Session
  include Gitlab

  attribute :id, Integer
  attribute :name, String
  attribute :private_token, String
end
