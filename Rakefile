# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/sql/version.rb'

Hoe.spec('sql') do |p|
  p.developer 'Dray Lacy', 'dray@izea.com'
  p.version = SQL::VERSION::STRING
  p.license("MIT")
end

GENERATED_PARSER = 'lib/sql/parser.racc.rb'
GENERATED_LEXER = 'lib/sql/parser.rex.rb'

file GENERATED_LEXER => 'lib/sql/parser.rex' do |t|
  sh "rex -o #{t.name} #{t.prerequisites.first}"
end

file GENERATED_PARSER => 'lib/sql/parser.racc' do |t|
  sh "racc -o #{t.name} #{t.prerequisites.first}"
end

desc "Generate parser files"
task :parser => [GENERATED_LEXER, GENERATED_PARSER]

# Make sure the parser's up-to-date when we test.
Rake::Task['test'].prerequisites << :parser

# Make sure the generated parser gets included in the manifest.
Rake::Task['check_manifest'].prerequisites << :parser

# vim: syntax=Ruby
