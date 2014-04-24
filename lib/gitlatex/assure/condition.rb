module Gitlatex::Assure
  module ConditionMethods
    def condition(expr, *args)
      callee = self.method(expr) if expr.is_a?(Symbol)
      3.times do |i|
        return if "Check condition '#{expr}'".emph.puts_with_check do
          callee.call(*args)
        end
        "  try to ensure the condition".puts_with do
          yield
        end
      end
    end
  end

  Definition.send :include, ConditionMethods
end
