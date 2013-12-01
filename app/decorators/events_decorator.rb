class EventsDecorator < PaginationDecorator
  def page(page)
    EventsDecorator.decorate(object.page)
  end
end
