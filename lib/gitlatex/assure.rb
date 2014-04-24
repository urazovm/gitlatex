module Gitlatex::Assure
  extend ActiveSupport::Concern

  class Definition
    def initialize(&block)
      instance_eval &block
    end
  end

  module ClassMethods
    def before(&block)
      (@befores ||= []) << block
    end
    def assure(name, &block)
      self.send :define_singleton_method, "assure_#{name}" do
        (@befores || []).each(&:call)
        Definition.new &block
      end
    end
  end
end

Dir[File.expand_path('../assure/*.rb', __FILE__)].each{|f| require f}
