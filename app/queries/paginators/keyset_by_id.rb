module Paginators
  class KeysetById
    DEFAULT_PER_PAGE = 10
    DEFAULT_RELATION = Building.includes(:address)

    # Initialize the paginator with optional parameters
    #
    # @param after_id [Integer] the ID after which to paginate
    # @param per_page [Integer] the number of records per page
    # @param relation [ActiveRecord::Relation] the relation to paginate
    def initialize(after_id: nil, per_page: DEFAULT_PER_PAGE, relation: DEFAULT_RELATION)
      @after_id = after_id
      @per_page = per_page.to_i
      @relation = relation
    end

    # Fetches the paginated results based on the provided parameters
    #
    # @return [ActiveRecord::Relation] the paginated records
    def call
      paginated_relation
    end

    private

    attr_reader :after_id, :per_page, :relation

    def paginated_relation
      after_id.present? ? paginated_with_after_id : paginated_without_after_id
    end

    def paginated_with_after_id
      relation.where('id > ?', after_id).order(id: :asc).limit(per_page)
    end

    def paginated_without_after_id
      relation.order(id: :asc).limit(per_page)
    end
  end
end
