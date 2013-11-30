class BuildDecorator < Draper::Decorator
  delegate :commit_id

  def log
    h.raw object.log
  end
  
  def path
    h.project_build_path(object.project_id, object)
  end
  def title(status=nil)
    status ||= object.status
    case status.to_sym
    when :wating
      I18n.t("builds.build.titles.wating")
    end
  end
  def message(status=nil)
    status ||= object.status
    h.capture do
      h.concat h.content_tag(:small, h.t("builds.build.branch", branch: object.branch))
      h.concat h.tag(:br)
      h.concat h.content_tag(:small, h.t("builds.build.commit_id", id: object.commit_id))
      h.concat h.content_tag(:pre, object.commit_message)
    end
  end
  def short
    h.capture do
      h.concat h.content_tag(:small, h.time_ago_in_words(object.updated_at))
      h.concat h.tag(:br)
      h.concat h.content_tag(:span, h.t("builds.build.branch", branch: object.branch))
    end
  end
end
