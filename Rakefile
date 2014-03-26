require 'rubygems'
require './lib/sql/version.rb'

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
