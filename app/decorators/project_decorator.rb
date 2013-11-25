class ProjectDecorator < Draper::Decorator
  delegate_all
  def header
    h.capture do
      h.concat h.content_tag(:span, object.namespace.name + " / ", class: "project-namespace")
      h.concat h.content_tag(:span, object.name, class: "project-name")
    end
  end
  def hooked_state
    if object.hooked?
      return "check", "primary"
    else
      return "minus", "default"
    end
  end
  def hook_button
    icon, color = hooked_state
    h.link_to h.project_path(object), method: 'put', id: "project-hook-button", class: "btn btn-#{color}", data: {remote: true, params: "hooked=#{!object.hooked}"} do
      h.capture do
        h.concat h.content_tag(:span, nil, class: "glyphicon glyphicon-#{icon}")
      end
    end
  end
  def hooked
    icon, color = hooked_state
    h.content_tag(:span,
      h.content_tag(:span, nil, class: "glyphicon glyphicon-#{icon}"),
      class: "label label-#{color} pull-right")
  end
  def item_header
    h.capture do
      h.concat hooked
      h.concat h.content_tag(:span, object.namespace.name + "/", class: "project-item-namespace")
      h.concat h.content_tag(:span, h.truncate(object.name, length: 25), class: "project-item-name")
    end
  end
  def activity
    h.capture do
      h.concat h.content_tag(:span, h.t('projects.decorator.last_activity'))
      h.concat h.content_tag(:span,
        if object.last_activity_at
          h.time_ago_in_words(object.last_activity_at)
        else
          h.t("projects.decorator.never")
        end, class: 'date')
    end
  end
end
