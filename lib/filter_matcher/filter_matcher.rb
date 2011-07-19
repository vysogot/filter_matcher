module FilterMatcher
  class Filterer
    def initialize(collection)
      @collection = collection
      @filters = []
    end

    def filter(&block)
      @filters << block
    end

    def match(&block)
      @match = block
    end

    def process
      @filters.each do |filter|
        filtered = filter.call(@collection)
        @collection = filtered.empty? ? @collection : filtered

        if @collection.size == 1
          @match.call(@collection.first)
          break
        end
      end
    end
  end

  def matcher(collection)
    filterer = Filterer.new(collection)
    yield filterer

    filterer.process
  end
end
