module Gitlab
  class ResponseArray < Array
    [:prev, :next, :first, :last].each do |rel|
      define_method "has_#{rel}?" do
        !instance_variable_get("@#{rel}").nil?
      end
      define_method "retrive_#{rel}" do
        Gitlab.client.get(instance_variable_get "@#{rel}")
      end
    end
    
    def initialize(response)
      super(response.parsed_response)
      (response.headers["link"] || "").split(",").each do |rel|
        url, type = rel.split(";")
        url = url.strip[1...-1]
        type = type.strip[5...-1]
        instance_variable_set "@#{type}", url
      end
    end
  end
end
