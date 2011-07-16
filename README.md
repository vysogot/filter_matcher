filter_matcher - filter your collections
===

How to install?
==

    gem install filter_matcher

What it does?
==

It filters a collection with defined filters. Launches the filters one by one on the collection until it finds a single result. When the result is found a final action is invoked.

Example
==

Lets say we have following data about people:

    db = [
      { :id => 1, :name => "John",  :age => 33, :homepage => "www.johny.com",     :matched => false },
      { :id => 2, :name => "Mike",  :age => 30, :homepage => "www.mikes.com",     :matched => false },
      { :id => 3, :name => "Johny", :age => 25, :homepage => "www.johny.com",     :matched => false },
      { :id => 4, :name => "Mike",  :age => 30, :homepage => "www.realmike.com",  :matched => false },
      { :id => 5, :name => "Dan",   :age => 25, :homepage => "www.danny.com",     :matched => false },
      { :id => 6, :name => "Dan",   :age => 40, :homepage => "www.fakedanny.com", :matched => false }
    ]

And we want to set the matched flag to true (or run any other more complicated action), only for the entries that match the input data. Lets say that input is:

    input = [
      { :name => "Mike", :age => 30, :homepage => "www.realmike.com" },
      { :name => "Dan", :homepage => "www.danny.com" }
    ]

First we need to specify how we want to filter our data to find the best match. As the filters run sequentially the order matters.

Lets say the most important is the name. If name filter finds a single result then this is a match. We can define the filter like:

    def name_filter(collection, name)
      collection.select { |element| element[:name] == name }
    end

The filter has to be named in the convention: <what_it_filters>_filter

If this is not sufficient we run another filter on the result of the previous one. Lets define another filter, saying that the second most important thing to find a match is age.

    def age_filter(collection, age)
      collection.select { |element| element[:age] == age}
    end

Simple and very similar to the previous one. Filters can have any logic you need. Lets define the last one - homepage filter.

    def homepage_filter(collection, homepage)
      collection.select { |element| element[:homepage] == homepage }
    end

Now, in order to run them all on the collection, we run the filter_and_match method:

    @input.each do |input|
      collection = @db

      filter_and_match collection, {
        :by_name => input[:name],
        :by_age  => input[:age],
        :by_homepage => input[:homepage]
      }
    end

If any filter returns an empty result then next filter is given the collection of the last not empty result or the original data itself.

If a single result will be found the elemnt_matched method will be triggered. In this example we just change the entry's flag:

  def element_matched(element)
    element[:matched] = true
  end

Full PeopleMatcher class example, that is responsible only for the matching is shown below:

    class PeopleMatcher
      include FilterMatcher

      attr_reader :db

      def initialize(db, input)
        @db, @input = db, input
      end

      def match
        @input.each do |input|
          collection = @db

          filter_and_match collection, {
            :by_name => input[:name],
            :by_age  => input[:age],
            :by_homepage => input[:homepage]
          }
        end
      end

      private

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

Feel free to contribute or give any feedback
==

Did you find it usefull any how? Please let me know, and if you can want to improve it just send me a pull request.
