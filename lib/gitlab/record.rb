module Gitlab::Record
  extend ActiveSupport::Concern

  included do |base|
    base.send :establish_connection, YAML.load_file("/home/git/gitlab/config/database.yml").symbolize_keys[Rails.env.to_sym]
  end
end
