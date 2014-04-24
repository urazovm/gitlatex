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
      puts " -- #{result.emph}"
      result
    end

    def puts_with_rescue!
      print self
      begin
        result = yield
        puts " -- \e[1;37;44msuccess\e[0m"
        return result
      rescue => e
        puts " -- \e[1;37;41mfailed\e[0m"
        raise e
      end
    end

    def emph
      "\e[1;34m#{self}\e[0m"
    end
  end
end
