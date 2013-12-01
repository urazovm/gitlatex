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

  def repo(prefix='project-repo')
    h.content_tag(:div, class: "repo input-group") do
      h.capture do
        h.concat(h.content_tag(:div, class: 'input-group-btn') do
          h.capture do
            h.concat h.link_to(h.t('projects.project.repo.ssh'), "##{prefix}-ssh", data: {toggle: 'tab'}, class: 'btn current')
            h.concat h.link_to(h.t('projects.project.repo.http'), "##{prefix}-http", data: {toggle: 'tab'}, class: 'btn')
          end
        end)
        h.concat(h.content_tag(:div, class: 'tab-content') do
          h.capture do
            h.concat(h.content_tag(:div, class: 'tab-pane active', id: "#{prefix}-ssh") do
              h.content_tag(:input, nil, class: 'form-control', value: object.ssh_url_to_repo)
            end)
            h.concat(h.content_tag(:div, class: 'tab-pane', id: "#{prefix}-http") do
              h.content_tag(:input, nil, class: 'form-control', value: object.http_url_to_repo)
            end)
          end
        end)
      end
    end
  end
end
