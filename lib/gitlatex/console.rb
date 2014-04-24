module Gitlatex
  module Console
    def puts_while
      puts self
      yield
    end
    
    def puts_with
      print self
      result = yield
      puts " -- done"
      result
    end

    def puts_with_check
      print self
      result = yield
      puts " -- #{result}"
      result
    end

    def puts_with_rescue!
      print self
      begin
        result = yield
        puts " -- success"
        return result
      rescue => e
        puts " -- failed"
        raise e
      end
    end

    def emph
      "\e[1;34m#{self}\e[0m"
    end
  end
end
