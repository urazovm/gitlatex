class PaginationDecorator < Draper::CollectionDecorator
  delegate :current_page, :total_page, :limit_value
end
