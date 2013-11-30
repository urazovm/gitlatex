class EventDecorator < Draper::Decorator
  decorates_association :eventable

  def path
    eventable.path
  end
  def status
    h.content_tag(:span, nil, class: "media-object event-icon event-icon-#{object.status || 'default'}")
  end
  def title
    h.content_tag(:h4, class: 'media-heading') do
      h.capture do
        if eventable.respond_to?(:title)
          h.concat eventable.title(object.status)
        else
          h.concat I18n.t("events.event.title")
        end
        h.concat " "
        h.concat h.content_tag(:small, h.time_ago_in_words(object.created_at))
      end
    end
  end
  def message
    h.content_tag(:p) do
      if eventable.respond_to?(:message)
        eventable.message(object.status)
      else
        I18n.t("events.event.message")
      end
    end
  end
end
