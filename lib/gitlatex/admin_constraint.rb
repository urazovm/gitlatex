class Gitlatex::AdminConstraint
  def matches?(request)
    (user = request.env['warden'].user) and user.admin?
  end
end
