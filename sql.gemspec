# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sql/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Dray Lacy']
  gem.email         = ['dray@izea.com']
  gem.description   = %q{Ruby library for parsing and generating SQL statements}
  gem.summary       = %q{Ruby library for parsing and generating SQL statements}
  gem.homepage      = 'https://github.com/omghax/sql'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "sql"
  gem.require_paths = ["lib"]
  gem.version       = '0.0.1'
end

