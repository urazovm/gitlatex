class Gitlatex::Build
  module Component
    extend ActiveSupport::Concern
    included do
      self.instance_variable_set :@priory, 0
      (@@components ||= []) << self
      attr_accessor :build, :context
    end

    def valid?
      !!context.error
    end

    module ClassMethods
      def priory(value)
        @priory = value
      end

      def <=> other
        self.instance_variable_get(:@priory) <=> other.instance_variable_get(:@priory)
      end
    end

    def self.make
      @@components.sort
    end
  end

  class Context
    attr_accessor :error
    attr_reader :variable
    
    def initialize
      @variable = Hash.new
    end
  end

  attr_reader :status, :error, :processes, :files
  
  def initialize(build)
    @components = Component.make
    @build = build
    @context = Context.new
    @status = :none
    @error = nil
    @processes = []
    @files = []
  end

  def perform
    @components.each do |klass|
      puts "Process #{klass.name}"
      component = klass.new
      component.build = @build
      component.context = @context
      component.perform if component.valid?
    end
  end
end

Dir[File.expand_path('../build/*.rb', __FILE__)].each{|f| require f}
