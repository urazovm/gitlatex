class ProjectDecorator < Draper::Decorator
  delegate :id
  delegate :name_with_namespace
  delegate :description
  delegate :owner
  delegate :created_at
  delegate :hooked?
  
  decorates_association :events, with: EventsDecorator
  decorates_association :builds

  def title(length=nil)
    name = length ? h.truncate(object.name, length: length) : object.name
    h.capture do
      h.concat h.content_tag(:span, object.namespace.name + " / ", class: "project-namespace")
      h.concat h.content_tag(:span, name, class: "project-name")
    end
  end
  def hook_button
    h.link_to(h.project_path(object),
      method: 'put',
      id: "project-hook-button",
      class: "btn-toggle" + (object.hooked ? " on" : ""),
      data: {remote: true}) do
      h.capture do
        h.concat h.content_tag(:span, h.t("projects.project.hook.on"), class: "btn-toggle-item")
        h.concat h.content_tag(:span, h.t("projects.project.hook.off"), class: "btn-toggle-item")
      end
    end
  end
  def hooked
    color = object.hooked? ? "primary" : "default"
    h.content_tag(:span,
      h.t("projects.decorator." + (object.hooked? ? "on" : "off")),
      class: "label label-#{color} pull-right")
  end

  def activity
    h.capture do
      h.concat h.content_tag(:span, h.t('projects.project.last_activity'))
      h.concat h.content_tag(:span,
        if object.last_activity_at
          h.t('datetime.ago', ago: h.time_ago_in_words(object.last_activity_at))
        else
          h.t("projects.decorator.never")
        end, class: 'date')
    end
  end

  def link
    h.link_to object.web_url, object.web_url
  end
end
