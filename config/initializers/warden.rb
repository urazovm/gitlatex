Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :gitlab
  manager.failure_app = SessionsController
end

# Setup Session Serialization
class Warden::SessionSerializer
  def serialize(record)
    [record.class.name, record.id]
  end
  
  def deserialize(keys)
    klass, id, token = keys
    klass.constantize.where(id: id).first
  end
end

# Declare your strategies here
Warden::Strategies.add(:gitlab) do
  def valid?
    params.has_key?(:user) && params[:user].has_key?(:password) && params[:user].has_key?(:login)
  end
  
  def authenticate!
    user = User.authenticate(params[:user][:login],params[:user][:password])
    if user
      success!(user)
    else
      fail()
    end
  end
end
