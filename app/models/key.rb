class Key
  include Gitlab

  attribute :id, Integer
  attribute :title, String
  attribute :key, String
  attribute :created_at, DateTime

  class << self
    def host_key
      id_rsa = File.open(File.join(ENV["HOME"], ".ssh", "id_rsa.pub")).read()
      id_rsa.strip()
    end
  end
end
