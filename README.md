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

    m.filter do |col|
      col.select { |element| element[:name] == name }
    end

If this is not sufficient we run another filter on the result of the previous one. Lets define another filter, saying that the second most important thing to find a match is age.

    m.filter do |col|
      col.select { |element| element[:age] == age}
    end

Simple and very similar to the previous one. Filters can have any logic you need. Lets define the last one - homepage filter.

    m.filter do |col|
      col.select { |element| element[:homepage] == homepage }
    end

Now, in order to run them all on the collection, we run the matcher method:

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

If any filter returns an empty result then next filter is given the collection of the last not empty result or the original data itself.
If a single result will be found the match block will be triggered. In this example we just change the entry's flag:

    m.match do |element|
      element[:matched] = true
    end

The expected result is the db matched like:

    db == [
      {:id => 1, :name => "John",  :age => 33, :homepage => "www.johny.com",     :matched => false}
      {:id => 2, :name => "Mike",  :age => 30, :homepage => "www.mikes.com",     :matched => false}
      {:id => 3, :name => "Johny", :age => 25, :homepage => "www.johny.com",     :matched => false}
      {:id => 4, :name => "Mike",  :age => 30, :homepage => "www.realmike.com",  :matched => true}
      {:id => 5, :name => "Dan",   :age => 25, :homepage => "www.danny.com",     :matched => true}
      {:id => 6, :name => "Dan",   :age => 40, :homepage => "www.fakedanny.com", :matched => false}
    ]

Full PeopleMatcher class example, that is responsible only for the matching is shown below:

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

Visual example
==
Filtering a collection

    [1,2,3] --first_filter--> [2,3] ---second_filter--> [2] -> match

    [1,2,3] --first_filter--> [] --> [1,2,3] --second_filter--> [3] -> match

    [1,2,3] --first_filter--> [1,2] --second_filter--> [1,2] --third_filter--> [1] -> match

    [1,2,3] --first_filter--> [] --> [1,2,3] --second_filter--> [] --> [1,2,3] --third_filter--> [] -> no match

    [1,2,3] --first_filter--> [1,2,3] --second_filter--> [2,3] --third_filter--> [2,3] -> no match

Filtering real data by SQL or JS
==

Remeber that often you can filter your data much more efficient with DB languages. This filtering method should be used when the filtering logic is highly application-dependent. Good SQL query (or smart map reduce) before application filter-matching is always a better approach.

Feel free to contribute or give any feedback
==

Did you find it usefull any how? Please let me know, and if you can want to improve it just send me a pull request.

Contributors
==

[Albert Llop](https://github.com/mrsimo)
[Sebastian Röbke](https://github.com/boosty)
