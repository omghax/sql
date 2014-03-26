# SQL

http://github.com/omghax/sql

## DESCRIPTION:

Ruby library for parsing and generating SQL statements.

## FEATURES/PROBLEMS:

* Parse arbitrary SQL strings into an AST (abstract syntax tree), which can
  then be traversed.

* Allows your code to understand and manipulate SQL in a deeper way than
  just using string manipulation.

## SYNOPSIS:

Here's an example of manually building an AST. It's extremely verbose at the
moment, but that should be mitigated a bit when I come up with a DSL for
building these trees.

```ruby
    >> require 'rubygems'
    >> require 'sql'

    # Let's build a tree representing the SQL statement
    # "SELECT * FROM users WHERE id = 1"
    # We'll start from the rightmost side, and work our way left as we go.

    # First, the integer constant, "1"
    >> integer_constant = SQL::Statement::Integer.new(1)
    >> integer_constant.to_sql
    => "1"

    # Now the column reference, "id"
    >> column_reference = SQL::Statement::Column.new('id')
    >> column_reference.to_sql
    => "id"

    # Now we'll combine the two using an equals operator, to create a search
    # condition
    >> search_condition = SQL::Statement::Equals.new(column_reference, integer_constant)
    >> search_condition.to_sql
    => "id = 1"

    # Next we'll feed that search condition to a where clause
    >> where_clause = SQL::Statement::WhereClause.new(search_condition)
    >> where_clause.to_sql
    => "WHERE id = 1"

    # Next up is the FROM clause.  First we'll build a table reference
    >> users = SQL::Statement::Table.new('users')
    >> users.to_sql
    => "users"

    # Now we'll feed that table reference to a from clause
    >> from_clause = SQL::Statement::FromClause.new(users)
    >> from_clause.to_sql
    => "FROM users"

    # Now to combine the FROM and WHERE clauses to form a table expression
    >> table_expression = SQL::Statement::TableExpression.new(from_clause, where_clause)
    >> table_expression.to_sql
    => "FROM users WHERE id = 1"

    # Now we need to represent the asterisk "*"
    >> all = SQL::Statement::All.new
    >> all.to_sql
    => "*"

    # Now we're ready to hand off these objects to a select statement
    >> select_statement = SQL::Statement::Select.new(all, table_expression)
    >> select_statement.to_sql
    => "SELECT * FROM users WHERE id = 1"
```

== ROADMAP

These features aren't currently implemented, but I have plans to add them in
the future. Stay tuned.

Eventually I plan to implement a SQL parser that will generate the tree
structure for you, based on an input string of SQL.

```ruby
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
```

## REQUIREMENTS:

* Ruby (duh)
* RubyGems
* Hoe >= 1.6.0

## INSTALL:

    $ sudo gem install omghax-sql --source http://gems.github.com

## LICENSE:

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
