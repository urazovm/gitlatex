module Gitlatex::Gitlab
  extend ActiveSupport::Concern

end

Dir[File.expand_path('../gitlab/*.rb', __FILE__)].each{|f| require f}
