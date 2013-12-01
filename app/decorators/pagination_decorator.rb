class PaginationDecorator < Draper::CollectionDecorator
  delegate :current_page, :total_pages, :limit_value

  def page(page)
    self.class.decorate(object.page(page))
  end
end
