module Gitlab
  class Client
    module Projects
      def all_projects(options={})
        get("/projects/all", :query => options)
      end
      
      def owned_projects(options={})
        get("/projects/owned", :query => options)
      end
    end
  end
end
