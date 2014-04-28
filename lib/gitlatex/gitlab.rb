module Gitlatex::Gitlab
end

Dir[File.expand_path('../gitlab/*.rb', __FILE__)].each{|f| require f}
