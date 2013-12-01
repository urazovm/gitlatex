class ProjectDecorator < Draper::Decorator
  delegate :id
  delegate :name_with_namespace
  delegate :web_url
  delegate :ssh_url_to_repo
  delegate :http_url_to_repo
  delegate :description
  delegate :owner
  delegate :created_at
  delegate :hooked?
  
  decorates_association :events, with: EventsDecorator
  decorates_association :builds
  
  def header
    h.capture do
      h.concat h.content_tag(:span, object.namespace.name + " / ", class: "project-namespace")
      h.concat h.content_tag(:span, object.name, class: "project-name")
    end
  end
  def hooked_color
    object.hooked? ? "primary" : "default"
  end
  def hook_button
    h.link_to(h.project_path(object),
      method: 'put',
      id: "project-hook-button",
      class: "btn-toggle" + (object.hooked ? " on" : ""),
      data: {remote: true}) do
      h.capture do
        h.concat h.content_tag(:span, h.t("projects.decorator.on"), class: "btn-toggle-item")
        h.concat h.content_tag(:span, h.t("projects.decorator.off"), class: "btn-toggle-item")
      end
    end
  end
  def hooked
    h.content_tag(:span,
      h.t("projects.decorator." + (object.hooked? ? "on" : "off")),
      class: "label label-#{hooked_color} pull-right")
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
