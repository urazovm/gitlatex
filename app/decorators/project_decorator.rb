class ProjectDecorator < Draper::Decorator
  delegate_all
  def item_header
    h.capture do
      begin
        if object.hooked?
          icon, color = "check", "primary"
        else
          icon, color = "minus", "default"
        end
        h.concat h.content_tag(:span,
          h.content_tag(:span, nil, class: "glyphicon glyphicon-#{icon}"),
          class: "label label-#{color} pull-right")
      end
      h.concat h.content_tag(:span, object.namespace.name + "/", class: "project-item-namespace")
      h.concat h.content_tag(:span, h.truncate(object.name, length: 25), class: "project-item-name")
    end
  end
  def item_text
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
