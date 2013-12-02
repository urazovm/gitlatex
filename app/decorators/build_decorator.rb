class BuildDecorator < Draper::Decorator
  delegate :commit_id

  decorates_association :files

  def error
    if object.error.nil?
      nil
    else
      h.content_tag(:div, object.error, class: 'alert alert-danger')
    end
  end

  def log
    h.capture do
      object.log.each do |log|
        if log.is_a?(Symbol)
          h.concat h.content_tag(:h3, I18n.t("builds.build.log.process", command: log.to_s))
        else
          h.concat h.content_tag(:strong, log[:command])
          h.concat h.tag(:br)
          h.concat h.raw log[:output].gsub(/\n/, h.tag(:br).to_s)
        end
      end
    end
  end
  
  def path
    h.project_build_path(object.project_id, object)
  end
  def title(status=nil)
    status ||= object.status
    case status.to_sym
    when :wating
      I18n.t("builds.build.titles.wating")
    when :success
      I18n.t("builds.build.titles.success")
    when :error
      I18n.t("builds.build.titles.error")
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
