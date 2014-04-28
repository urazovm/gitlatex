require 'gitlatex/assure/condition'
module Gitlatex::Assure
  class DirectoryAssure
    include Gitlatex::Assure::ConditionMethods
    
    def initialize(path, &block)
      @path = path
      instance_exec path, &block
    end

    def exists?(expr=nil, *args, &block)
      if block_given?
        callee = block
      elsif expr.is_a?(Symbol)
        callee = self.method(expr)
      else
        callee = ->{ Dir.mkdir(@path, expr) }
      end
      3.times do |i|
        return if "  exists?".puts_with_check do
          Dir.exists?(@path)
        end
        "    try create".puts_with do
          callee.call *args
        end
      end
      raise "Failed assure '#{@path}' exists"
    end

    def permission?(value)
      3.times do |i|
        return if "  permission is equals to #{value.to_s(8)}?".puts_with_check do
          (File.stat(@path).mode & 0777) == value
        end
        "    change permission of '#{@path}'".puts_with do
          File.chmod value, @path
        end
      end
      raise "Failed assure the permission of '#{@path}'"
    end
  end
  
  module DirectoryMethods
    def directory(path, &block)
      "Check directory #{path}:".emph.puts_while do
        DirectoryAssure.new(path, &block)
      end
    end
  end

  Definition.send :include, DirectoryMethods
end
