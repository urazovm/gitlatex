module Gitlab
  class Client
    module SystemHooks
      def hooks(options={})
        get("/hooks", :query => options)
      end

      def create_hook(url)
        post("/hooks", :body => {:url => url})
      end

      def hook(id)
        get("/hooks/#{id}")
      end

      def delete_hook(id)
        delete("/hooks/#{id}")
      end
    end
  end
end
