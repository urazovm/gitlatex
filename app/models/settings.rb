class Settings < Settingslogic
  source "#{Rails.root}/config/gitlatex.yml"
  namespace Rails.env
end
