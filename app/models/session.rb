class Session
  include Gitlab

  attribute :id, Integer
  attribute :name, String
  attribute :private_token, String

  def self.sign_in(params, session)
    response = post("/session", query: params)
    if response.success?
      session[:id] = response["id"]
      session[:name] = response["name"]
      session[:private_token] = response["private_token"]
      true
    else
      false
    end
  end
end
