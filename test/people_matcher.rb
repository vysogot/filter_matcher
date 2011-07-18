#
# example class that uses filter matcher module
#
# @db:
# represents data from which machter tries to filter
# a single result
#
# @input:
# criteria for maching
#

require 'filter_matcher'

class PeopleMatcher
  include FilterMatcher

  attr_reader :db

  def initialize(db, input)
    @db, @input = db, input
  end

  #
  # run filters on all data for every input element
  #
  def match
    @input.each do |input|
      collection = @db

      #
      # filters are run sequentially until they find
      # a single result
      #
      # they are called by the following convention:
      # :by_<what_it_filters => paramters of <what_it_filters>_filter method
      #
      # when one of the filters reveal a single result
      # next filters are not run for current input
      #
      filter_and_match collection, {
        :by_name => input[:name],
        :by_age  => input[:age],
        :by_homepage => input[:homepage]
      }
    end
  end

  private

  #
  # filters are named by the following convention:
  # <what_it_filters>_filter
  #
  # every filter should return a filtered result
  #
  def name_filter(collection, name)
    collection.select { |element| element[:name] == name }
  end

  def age_filter(collection, age)
    collection.select { |element| element[:age] == age}
  end

  def homepage_filter(collection, homepage)
    collection.select { |element| element[:homepage] == homepage }
  end

  def element_matched(element)
    element[:matched] = true
  end
end
