class BuildDecorator < Draper::Decorator
  def title(status)
    case status.to_sym
    when :wating
      I18n.t("builds.build.titles.wating")
    end
  end
  def message(status)
    h.capture do
      h.concat h.content_tag(:small, h.t("builds.build.branch", branch: object.ref.split('refs/heads/')[1]))
      h.concat h.tag(:br)
      h.concat h.content_tag(:small, h.t("builds.build.commit_id", id: object.commit_id))
      h.concat h.content_tag(:pre, object.commit_message)
    end
  end
end
