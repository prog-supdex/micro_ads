module PaginationLinks
  extend self

  def pagination_links(pagy:)
    return {} if pagy.count.zero?

    links = {
      first: pagination_link(page: 1),
      last: pagination_link(page: pagy.count)
    }

    links[:next] = pagination_link(page: pagy.next) if pagy.next.present?
    links[:prev] = pagination_link(page: pagy.prev) if pagy.prev.present?

    links
  end

  private

  #TODO временное решение, исправить
  def pagination_link(page:)
    "/ads?page=#{page}"
  end
end
