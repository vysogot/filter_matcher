require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class FirstFromTopMatcherTest < Test::Unit::TestCase

  def run_matcher(input)
    input.each do |input|
      collection = @db

      matcher(collection, :first_from_top) do |m|
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

  def setup
    @db = [
      { :id => 1, :name => "John",  :age => 33, :homepage => "www.johny.com",     :matched => false },
      { :id => 2, :name => "Mike",  :age => 30, :homepage => "www.mikes.com",     :matched => false },
      { :id => 3, :name => "Johny", :age => 25, :homepage => "www.johny.com",     :matched => false },
      { :id => 4, :name => "Mike",  :age => 30, :homepage => "www.realmike.com",  :matched => false },
      { :id => 5, :name => "Dan",   :age => 25, :homepage => "www.danny.com",     :matched => false },
      { :id => 6, :name => "Dan",   :age => 40, :homepage => "www.fakedanny.com", :matched => false }
    ]
  end

  def test_filters_by_name
    input = [
      { :name => "John" },
      { :name => "Johny" }
    ]

    run_matcher(input)

    assert_matched(@db, input, [1, 3])
  end

  def test_filters_by_name_and_then_by_age
    input = [
      { :name => "Dan", :age => 40 }
    ]

    run_matcher(input)

    assert_matched(@db, input, [6])
  end

  def test_filters_by_name_and_then_by_age_and_then_by_homepage
    input = [
      { :name => "Mike", :age => 30, :homepage => "www.realmike.com" },
      { :name => "Dan", :homepage => "www.danny.com" }
    ]

    run_matcher(input)

    assert_matched(@db, input, [4, 5])
  end

  def test_filters_by_age_and_then_by_homepage_name_not_given
    input = [
      { :age => 25, :homepage => "www.johny.com" }
    ]

    run_matcher(input)

    assert_matched(@db, input, [3])
  end

  def test_doesnt_match_if_nothing_matched
    input = [
      { :name => "George" }
    ]

    run_matcher(input)

    assert_matched(@db, input, [])
  end

  def test_doesnt_match_if_many_matched
    input = [
      { :name => "Mike", :age => 30 }
    ]

    run_matcher(input)

    assert_matched(@db, input, [2])
  end
end
