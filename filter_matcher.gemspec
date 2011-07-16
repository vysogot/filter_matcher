# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "filter_matcher/version"

Gem::Specification.new do |s|
  s.name        = "filter_matcher"
  s.version     = FilterMatcher::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jakub Godawa"]
  s.email       = ["jakub.godawa@gmail.com"]
  s.homepage    = "http://github.com/vysogot/filter_matcher"
  s.summary     = %q{FilterMatcher makes it easy to find a match in a collection}
  s.description = %q{FilterMatcher is helpful when it comes to find a single match in the collection
  by a group of filters. Every filter is can be easly defined and chained with others. Filters narrow the
  collection sequantially.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
