require 'bundler/setup'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/people_matcher')

class PeopleMatcherTest < Test::Unit::TestCase
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

    assert_matched(input, [1, 3])
  end

  def test_filters_by_name_and_then_by_age
    input = [
      { :name => "Dan", :age => 40 }
    ]

    assert_matched(input, [6])
  end

  def test_filters_by_name_and_then_by_age_and_then_by_homepage
    input = [
      { :name => "Mike", :age => 30, :homepage => "www.realmike.com" },
      { :name => "Dan", :homepage => "www.danny.com" }
    ]

    assert_matched(input, [4, 5])
  end

  def test_filters_by_age_and_then_by_homepage_name_not_given
    input = [
      { :age => 25, :homepage => "www.johny.com" }
    ]

    assert_matched(input, [3])
  end

  def test_doesnt_match_if_nothing_matched
    input = [
      { :name => "George" }
    ]

    assert_matched(input, [])
  end

  def test_doesnt_match_if_many_matched
    input = [
      { :name => "Mike", :age => 30 }
    ]

    assert_matched(input, [])
  end

  private

  def assert_matched(input, matched)
    matcher = PeopleMatcher.new(@db, input)
    matcher.match

    matcher.db.select {|x| matched.include?(x[:id]) }.each do |entry|
      assert(entry[:matched], "Matched expected: #{entry.inspect}")
    end

    matcher.db.reject {|x| matched.include?(x[:id]) }.each do |entry|
      assert(!entry[:matched], "Not matched expected: #{entry.inspect}")
    end
  end
end
