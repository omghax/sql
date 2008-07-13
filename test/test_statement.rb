require File.dirname(__FILE__) + '/../lib/sql'
require 'test/unit'

class TestStatement < Test::Unit::TestCase
  def test_select
    assert_sql 'SELECT * FROM users', SQL::Statement::Select.new(SQL::Statement::All.new, SQL::Statement::TableExpression.new(SQL::Statement::FromClause.new(SQL::Statement::Table.new('users'))))
  end

  def test_select_list
    assert_sql 'id', SQL::Statement::SelectList.new(SQL::Statement::Column.new('id'))
    assert_sql 'id, name', SQL::Statement::SelectList.new([SQL::Statement::Column.new('id'), SQL::Statement::Column.new('name')])
  end

  def test_distinct
    assert_sql 'DISTINCT(username)', SQL::Statement::Distinct.new(SQL::Statement::Column.new('username'))
  end

  def test_all
    assert_sql '*', SQL::Statement::All.new
  end

  def test_table_expression
    assert_sql 'FROM users WHERE id = 1 GROUP BY name', SQL::Statement::TableExpression.new(SQL::Statement::FromClause.new(SQL::Statement::Table.new('users')), SQL::Statement::WhereClause.new(SQL::Statement::Equals.new(SQL::Statement::Column.new('id'), SQL::Statement::Integer.new(1))), SQL::Statement::GroupByClause.new(SQL::Statement::Column.new('name')))
  end

  def test_from_clause
    assert_sql 'FROM users', SQL::Statement::FromClause.new(SQL::Statement::Table.new('users'))
  end

  def test_order_clause
    assert_sql 'ORDER BY name DESC', SQL::Statement::OrderClause.new(SQL::Statement::Descending.new(SQL::Statement::Column.new('name')))
    assert_sql 'ORDER BY id ASC, name DESC', SQL::Statement::OrderClause.new([SQL::Statement::Ascending.new(SQL::Statement::Column.new('id')), SQL::Statement::Descending.new(SQL::Statement::Column.new('name'))])
  end

  def test_having_clause
    assert_sql 'HAVING id = 1', SQL::Statement::HavingClause.new(SQL::Statement::Equals.new(SQL::Statement::Column.new('id'), SQL::Statement::Integer.new(1)))
  end

  def test_group_by_clause
    assert_sql 'GROUP BY name', SQL::Statement::GroupByClause.new(SQL::Statement::Column.new('name'))
    assert_sql 'GROUP BY name, status', SQL::Statement::GroupByClause.new([SQL::Statement::Column.new('name'), SQL::Statement::Column.new('status')])
  end

  def test_where_clause
    assert_sql 'WHERE 1 = 1', SQL::Statement::WhereClause.new(SQL::Statement::Equals.new(SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(1)))
  end

  def test_or
    assert_sql '(FALSE OR FALSE)', SQL::Statement::Or.new(SQL::Statement::False.new, SQL::Statement::False.new)
  end

  def test_and
    assert_sql '(TRUE AND TRUE)', SQL::Statement::And.new(SQL::Statement::True.new, SQL::Statement::True.new)
  end

  def test_is_null
    assert_sql '1 IS NULL', SQL::Statement::IsNull.new(SQL::Statement::Integer.new(1))
  end

  def test_like
    assert_sql "'hello' LIKE 'h%'", SQL::Statement::Like.new(SQL::Statement::String.new('hello'), SQL::Statement::String.new('h%'))
  end

  def test_in
    assert_sql '1 IN (1, 2, 3)', SQL::Statement::In.new(SQL::Statement::Integer.new(1), [SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(2), SQL::Statement::Integer.new(3)])
  end

  def test_between
    assert_sql '2 BETWEEN 1 AND 3', SQL::Statement::Between.new(SQL::Statement::Integer.new(2), SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(3))
  end

  def test_gte
    assert_sql '1 >= 1', SQL::Statement::GreaterOrEquals.new(SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(1))
  end

  def test_lte
    assert_sql '1 <= 1', SQL::Statement::LessOrEquals.new(SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(1))
  end

  def test_gt
    assert_sql '1 > 1', SQL::Statement::Greater.new(SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(1))
  end

  def test_lt
    assert_sql '1 < 1', SQL::Statement::Less.new(SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(1))
  end

  def test_equals
    assert_sql '1 = 1', SQL::Statement::Equals.new(SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(1))
  end

  def test_table
    assert_sql 'users', SQL::Statement::Table.new('users')
  end

  def test_qualified_column
    assert_sql 'users.id', SQL::Statement::QualifiedColumn.new('users', 'id')
  end

  def test_column
    assert_sql 'id', SQL::Statement::Column.new('id')
  end

  def test_true
    assert_sql 'TRUE', SQL::Statement::True.new
  end

  def test_false
    assert_sql 'FALSE', SQL::Statement::False.new
  end

  def test_null
    assert_sql 'NULL', SQL::Statement::Null.new
  end

  def test_datetime
    assert_sql "'2008-07-01 12:34:56'", SQL::Statement::DateTime.new(Time.local(2008, 7, 1, 12, 34, 56))
  end

  def test_date
    assert_sql "'2008-07-01'", SQL::Statement::Date.new(Date.new(2008, 7, 1))
  end

  def test_string
    assert_sql "'foo'", SQL::Statement::String.new('foo')

    # # FIXME
    # assert_sql "'O\\\'rly'", SQL::Statement::String.new("O'rly")
  end

  def test_float
    assert_sql '1.1', SQL::Statement::Float.new(1.1)
  end

  def test_integer
    assert_sql '1', SQL::Statement::Integer.new(1)
  end

  private

  def assert_sql(expected, ast)
    assert_equal expected, ast.to_sql
  end
end
