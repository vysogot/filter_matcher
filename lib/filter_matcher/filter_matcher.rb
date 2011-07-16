module FilterMatcher

  #
  # define filter in a class that uses this module
  # named like:
  #   - name_filter
  #   - age_filter
  #
  # they should a filtered array
  #

  def filter_and_match(collection, filters)
    filters.each do |key, param|
      method_name = key.to_s.tr('by_', '') + "_filter"
      filtered = send(method_name.to_sym, collection, param)
      collection = filtered.empty? ? collection : filtered
      if collection.size == 1
        element_matched(collection.first)
        break
      end
    end
  end
end
