require 'bundler/setup'
require 'test/unit'
require 'filter_matcher/filter_matcher'

include FilterMatcher

def assert_matched(db, input, matched)
  db.select {|x| matched.include?(x[:id]) }.each do |entry|
    assert(entry[:matched], "Matched expected: #{entry.inspect}")
  end

  db.reject {|x| matched.include?(x[:id]) }.each do |entry|
    assert(!entry[:matched], "Not matched expected: #{entry.inspect}")
  end
end
