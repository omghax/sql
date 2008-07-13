= SQL

http://github.com/omghax/sql

== DESCRIPTION:

Ruby library for parsing and generating SQL statements.

== FEATURES/PROBLEMS:

  * Parse arbitrary SQL strings into an AST (abstract syntax tree), which can
    then be traversed.

  * Allows your code to understand and manipulate SQL in a deeper way than
    just using string manipulation.

== SYNOPSIS:

  >> require 'rubygems'
  >> require 'sql'
  >> parser = SQL::Parser.new

  # Build the AST from a SQL statement
  >> ast = parser.scan_str('SELECT * FROM users WHERE id = 1')

  # Find which columns where selected in the FROM clause
  >> ast.select_list.to_sql
  => "*"

  # Output the table expression as SQL
  >> ast.table_expression.to_sql
  => "FROM users WHERE id = 1"

  # Drill down into the WHERE clause, to examine every piece
  >> ast.table_expression.where_clause.to_sql
  => "WHERE id = 1"
  >> ast.table_expression.where_clause.search_condition.to_sql
  => "id = 1"
  >> ast.table_expression.where_clause.search_condition.left.to_sql
  => "id"
  >> ast.table_expression.where_clause.search_condition.right.to_sql
  => "1"

== REQUIREMENTS:

  * Ruby (duh)
  * RubyGems
  * Hoe >= 1.6.0

== INSTALL:

  $ sudo gem install omghax-sql --source http://gems.github.com

== LICENSE:

(The MIT License)

Copyright (c) 2008 Dray Lacy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
