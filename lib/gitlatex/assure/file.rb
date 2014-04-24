require 'gitlatex/assure/condition'
module Gitlatex::Assure
  class FileAssure
    include Gitlatex::Assure::ConditionMethods
    
    def initialize(path, &block)
      @path = path
      instance_exec path, &block
    end

    def exists?(expr=nil, *args, &block)
      if block_given?
        callee = block
      else
        callee = expr.is_a?(Symbol) ? self.method(expr) : expr
      end
      3.times do |i|
        return if "  exists?".puts_with_check do
          File.exists?(@path)
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
  
  module FileMethods
    def file(path, &block)
      "Check file #{path}:".emph.puts_while do
        FileAssure.new(path, &block)
      end
    end
  end

  Definition.send :include, FileMethods
end
