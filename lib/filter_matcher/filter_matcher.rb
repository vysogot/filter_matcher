module FilterMatcher

  class Matcher
    class UnknownMatcherError < StandardError; end

    MATCHERS = [:single, :first_from_top]

    def initialize(collection, matcher_type)
      unless MATCHERS.include?(matcher_type)
        raise UnknownMatcherError,
          "No matcher #{matcher_type} found, select one of these: #{MATCHERS.join(', ')}"
      end

      @collection = collection
      @matcher = get_matcher(matcher_type)
    end

    def filter(&block)
      @matcher.filters << block
    end

    def match(&block)
      @match = block
    end

    def run
      @matcher.run(@collection, @match)
    end

    private

    def get_matcher(symbol)
      klass_name = symbol.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      klass_name << "Matcher"
      klass = Object.const_get(klass_name)
      klass.new
    end
  end

  # matches only when filters can narrow collection to one element
  class SingleMatcher
    attr_accessor :filters

    def initialize
      @filters = []
    end

    def run(collection, match)
      @filters.each do |filter|
        filtered = filter.call(collection)
        collection = filtered.empty? ? collection : filtered

        if collection.size == 1
          match.call(collection.first)
          break
        end
      end
    end
  end

  # matches the result from the top of the filtered collection
  # does not match only when filtered didn't filtered anything
  class FirstFromTopMatcher
    attr_accessor :filters

    def initialize
      @filters = []
    end

    def run(collection, match)
      last_filter_index = @filters.size - 1
      collection_init_size = collection.size
      @filters.each_with_index do |filter, index|
        filtered = filter.call(collection)
        collection = filtered.empty? ? collection : filtered

        if (collection.size == 1) ||
          ((last_filter_index == index) && (collection_init_size != collection.size))

          match.call(collection.first)
          break
        end
      end
    end
  end


  def matcher(collection, matcher_type)
    matcher = Matcher.new(collection, matcher_type)
    yield matcher

    matcher.run
  end
end
