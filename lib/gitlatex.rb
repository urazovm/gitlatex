module Gitlatex
end

require 'gitlatex/console.rb'

Dir[File.expand_path('../gitlab/*.rb', __FILE__)].each{|f| require f}
Dir[File.expand_path('../gitlatex/*.rb', __FILE__)].each{|f| require f}
