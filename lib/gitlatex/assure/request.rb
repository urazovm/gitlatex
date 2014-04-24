require 'gitlatex/assure/condition'
module Gitlatex::Assure
  class RequestAssure
    attr_reader :check
    
    def initialize(response, &block)
      @response = response
      @check = true
      instance_exec response, &block
    end

    def condition(expr, *args)
      callee = self.method(expr) if expr.is_a?(Symbol)
      return if (@check = "Check condition '#{expr}'".emph.puts_with_check do
        callee.call(*args)
      end)
      yield
    end 

    def error(type)
      yield if @response.is_a?(StandardError) and @response.is_a?(type)
    end

    def success
      yield unless @response.nil? or @response.is_a?(StandardError)
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
          rescue => e
            RequestAssure.new(e, &block)
          end
          return if RequestAssure.new(response, &block).check
        end
      end
    end
  end

  Definition.send :include, RequestMethods
end
