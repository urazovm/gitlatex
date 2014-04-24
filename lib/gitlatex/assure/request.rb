require 'gitlatex/assure/condition'
module Gitlatex::Assure
  class RequestAssure
    include Gitlatex::Assure::ConditionMethods

    attr_reader :check
    
    def initialize(response, &block)
      @response = response
      instance_exec response, &block
      @check = true
    end

    def error(type)
      yield if @response.is_a?(StandardError) and @response.is_a?(type)
    end
  end
  
  module RequestMethods
    def request(request, *args, &block)
      "Check request '#{request}':".emph.puts_while do
        3.times do |i|
          begin
            response = "  try to request #{request}".puts_with_rescue! do
              Gitlab.client.method(request).call(*args)
            end
            return if "  check conditions".puts_with_check do
              RequestAssure.new(response, &block).check
            end
          rescue => e
            RequestAssure.new(e, &block)
          end
        end
      end
    end
  end

  Definition.send :include, RequestMethods
end
