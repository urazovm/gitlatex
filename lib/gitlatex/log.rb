class Gitlatex::Log
  attr_accessor :command, :output

  def initialize(command, output)
    self.command = command
    self.output = output
  end
end
