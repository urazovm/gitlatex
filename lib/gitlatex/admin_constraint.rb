class Gitlatex::AdminConstraint
  def matches?(request)
    (user = request.env['warden'].user) and user.is_admin?
  end
end
