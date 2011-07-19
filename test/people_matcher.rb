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

     matcher(collection) do |m|
        m.filter do |col|
          col.select { |element| element[:name] == input[:name] }
        end

        m.filter do |col|
          col.select { |element| element[:age] == input[:age]}
        end

        m.filter do |col|
          col.select { |element| element[:homepage] == input[:homepage] }
        end

        m.match do |element|
          element[:matched] = true
        end
      end
    end
  end
end
