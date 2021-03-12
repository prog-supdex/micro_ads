class PagyService
  include Pagy::Backend

  ITEMS_COUNT = 25

  attr_reader :request, :scope

  def initialize(scope:, request:)
    @scope = scope
    @request = request
  end

  def call
    pagy(scope, items: ITEMS_COUNT)
  end

  private

  def pagy_get_vars(collection, vars)
    {
      count: collection.count,
      page: request.params['page'],
      items: vars[:items]
    }
  end
end
