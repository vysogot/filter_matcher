# filter_matcher

filter your collection with ease

## How to install?

    gem install filter_matcher

## What it does?

Invokes a method on filtered elements from a collection.

## Example

Lets say we have following data about people:

```ruby
db = [
  { :id => 1, :name => "John",  :age => 33, :homepage => "www.johny.com",     :matched => false },
  { :id => 2, :name => "Mike",  :age => 30, :homepage => "www.mikes.com",     :matched => false },
  { :id => 3, :name => "Johny", :age => 25, :homepage => "www.johny.com",     :matched => false },
  { :id => 4, :name => "Mike",  :age => 30, :homepage => "www.realmike.com",  :matched => false },
  { :id => 5, :name => "Dan",   :age => 25, :homepage => "www.danny.com",     :matched => false },
  { :id => 6, :name => "Dan",   :age => 40, :homepage => "www.fakedanny.com", :matched => false }
]
```

And we want to match them with the following input:

```ruby
input = [
  { :name => "Mike", :age => 30, :homepage => "www.realmike.com" },
  { :name => "Dan", :homepage => "www.danny.com" }
]
```

We specifiy filters in order of importance and the method to be invoked on matched element(s):

```ruby
input.each do |input|
  matcher(db, :single) do |m|
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
```

The expected result is the db matched like:

```ruby
db == [
  {:id => 1, :name => "John",  :age => 33, :homepage => "www.johny.com",     :matched => false}
  {:id => 2, :name => "Mike",  :age => 30, :homepage => "www.mikes.com",     :matched => false}
  {:id => 3, :name => "Johny", :age => 25, :homepage => "www.johny.com",     :matched => false}
  {:id => 4, :name => "Mike",  :age => 30, :homepage => "www.realmike.com",  :matched => true}
  {:id => 5, :name => "Dan",   :age => 25, :homepage => "www.danny.com",     :matched => true}
  {:id => 6, :name => "Dan",   :age => 40, :homepage => "www.fakedanny.com", :matched => false}
]
```

## Visual examples

Filtering a collection with SingleMatcher

    [1,2,3] --first_filter--> [2,3] ---second_filter--> [2] -> match

    [1,2,3] --first_filter--> [] --> [1,2,3] --second_filter--> [3] -> match

    [1,2,3] --first_filter--> [1,2] --second_filter--> [1,2] --third_filter--> [1] -> match

    [1,2,3] --first_filter--> [] --> [1,2,3] --second_filter--> [] --> [1,2,3] --third_filter--> [] -> no match

    [1,2,3] --first_filter--> [1,2,3] --second_filter--> [2,3] --third_filter--> [2,3] -> no match

Filtering a collection with FirstFromTopMatcher

    [1,2,3] --first_filter--> [2,3] ---second_filter--> [2] -> matches 2

    [1,2,3] --first_filter--> [] --> [1,2,3] --second_filter--> [3] -> matches 3

    [1,2,3] --first_filter--> [1,2] --second_filter--> [1,2] --third_filter--> [1, 2] -> matches 1

    [1,2,3] --first_filter--> [] --> [1,2,3] --second_filter--> [] --> [1,2,3] --third_filter--> [] -> no match

    [1,2,3] --first_filter--> [1,2,3] --second_filter--> [2,3] --third_filter--> [2,3] -> matches 2


## Filtering class example

Full PeopleMatcher class example, that is responsible only for the matching could look like that:

```ruby
class PeopleMatcher
  include FilterMatcher

  attr_reader :db

  def initialize(db, input)
    @db, @input = db, input
  end

  def match
    @input.each do |input|
      collection = @db

     matcher(collection, :filter_type) do |m|
        m.filter do |col|
          # filtering code
        end

        m.filter do |col|
          # filtering code
        end

        m.match do |element|
          # match code
        end
      end
    end
  end
end
```

## Usecases

Matching JSON, csv or hash data. Helpful to apply any filter that cannot be applied on DB level.

## Contribution

Did you find it usefull anyhow?
Please let me know, and if you want to improve it just send me an email or pull request.

Contributors:

[Albert Llop](https://github.com/mrsimo),
[Sebastian Röbke](https://github.com/boosty)
