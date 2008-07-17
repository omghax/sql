require File.dirname(__FILE__) + '/../lib/sql'
require 'test/unit'

class TestStatement < Test::Unit::TestCase
  def test_select
    assert_sql 'SELECT 1', SQL::Statement::Select.new(SQL::Statement::Integer.new(1))
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

  def test_right_join
    assert_sql 't1 RIGHT JOIN t2 ON t1.a = t2.a', SQL::Statement::RightJoin.new(SQL::Statement::Table.new('t1'), SQL::Statement::Table.new('t2'), SQL::Statement::Equals.new(SQL::Statement::QualifiedColumn.new('t1', 'a'), SQL::Statement::QualifiedColumn.new('t2', 'a')))
  end

  def test_left_outer_join
    assert_sql 't1 LEFT OUTER JOIN t2 ON t1.a = t2.a', SQL::Statement::LeftOuterJoin.new(SQL::Statement::Table.new('t1'), SQL::Statement::Table.new('t2'), SQL::Statement::Equals.new(SQL::Statement::QualifiedColumn.new('t1', 'a'), SQL::Statement::QualifiedColumn.new('t2', 'a')))
  end

  def test_left_join
    assert_sql 't1 LEFT JOIN t2 ON t1.a = t2.a', SQL::Statement::LeftJoin.new(SQL::Statement::Table.new('t1'), SQL::Statement::Table.new('t2'), SQL::Statement::Equals.new(SQL::Statement::QualifiedColumn.new('t1', 'a'), SQL::Statement::QualifiedColumn.new('t2', 'a')))
  end

  def test_inner_join
    assert_sql 't1 INNER JOIN t2 ON t1.a = t2.a', SQL::Statement::InnerJoin.new(SQL::Statement::Table.new('t1'), SQL::Statement::Table.new('t2'), SQL::Statement::Equals.new(SQL::Statement::QualifiedColumn.new('t1', 'a'), SQL::Statement::QualifiedColumn.new('t2', 'a')))
  end

  def test_cross_join
    assert_sql 't1 CROSS JOIN t2', SQL::Statement::CrossJoin.new(SQL::Statement::Table.new('t1'), SQL::Statement::Table.new('t2'))
    assert_sql 't1 CROSS JOIN t2 CROSS JOIN t3', SQL::Statement::CrossJoin.new(SQL::Statement::CrossJoin.new(SQL::Statement::Table.new('t1'), SQL::Statement::Table.new('t2')), SQL::Statement::Table.new('t3'))
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

  def test_is_not_null
    assert_sql '1 IS NOT NULL', SQL::Statement::Not.new(SQL::Statement::Is.new(SQL::Statement::Integer.new(1), SQL::Statement::Null.new))
  end

  def test_is_null
    assert_sql '1 IS NULL', SQL::Statement::Is.new(SQL::Statement::Integer.new(1), SQL::Statement::Null.new)
  end

  def test_not_like
    assert_sql "'hello' NOT LIKE 'h%'", SQL::Statement::Not.new(SQL::Statement::Like.new(SQL::Statement::String.new('hello'), SQL::Statement::String.new('h%')))
  end

  def test_like
    assert_sql "'hello' LIKE 'h%'", SQL::Statement::Like.new(SQL::Statement::String.new('hello'), SQL::Statement::String.new('h%'))
  end

  def test_not_in
    assert_sql '1 NOT IN (1, 2, 3)', SQL::Statement::Not.new(SQL::Statement::In.new(SQL::Statement::Integer.new(1), [SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(2), SQL::Statement::Integer.new(3)]))
  end

  def test_in
    assert_sql '1 IN (1, 2, 3)', SQL::Statement::In.new(SQL::Statement::Integer.new(1), [SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(2), SQL::Statement::Integer.new(3)])
  end

  def test_not_between
    assert_sql '2 NOT BETWEEN 1 AND 3', SQL::Statement::Not.new(SQL::Statement::Between.new(SQL::Statement::Integer.new(2), SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(3)))
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

  def test_not_equals
    assert_sql '1 <> 1', SQL::Statement::Not.new(SQL::Statement::Equals.new(SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(1)))
  end

  def test_equals
    assert_sql '1 = 1', SQL::Statement::Equals.new(SQL::Statement::Integer.new(1), SQL::Statement::Integer.new(1))
  end

  def test_sum
    assert_sql 'SUM(messages_count)', SQL::Statement::Sum.new(SQL::Statement::Column.new('messages_count'))
  end

  def test_minimum
    assert_sql 'MIN(age)', SQL::Statement::Minimum.new(SQL::Statement::Column.new('age'))
  end

  def test_maximum
    assert_sql 'MAX(age)', SQL::Statement::Maximum.new(SQL::Statement::Column.new('age'))
  end

  def test_average
    assert_sql 'AVG(age)', SQL::Statement::Average.new(SQL::Statement::Column.new('age'))
  end

  def test_count
    assert_sql 'COUNT(*)', SQL::Statement::Count.new(SQL::Statement::All.new)
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

  def test_as
    assert_sql '1 AS a', SQL::Statement::As.new(SQL::Statement::Integer.new(1), 'a')
  end

  def test_multiply
    assert_sql '(2 * 2)', SQL::Statement::Multiply.new(SQL::Statement::Integer.new(2), SQL::Statement::Integer.new(2))
  end

  def test_divide
    assert_sql '(2 / 2)', SQL::Statement::Divide.new(SQL::Statement::Integer.new(2), SQL::Statement::Integer.new(2))
  end

  def test_add
    assert_sql '(2 + 2)', SQL::Statement::Add.new(SQL::Statement::Integer.new(2), SQL::Statement::Integer.new(2))
  end

  def test_subtract
    assert_sql '(2 - 2)', SQL::Statement::Subtract.new(SQL::Statement::Integer.new(2), SQL::Statement::Integer.new(2))
  end

  def test_unary_plus
    assert_sql '+1', SQL::Statement::UnaryPlus.new(SQL::Statement::Integer.new(1))
  end

  def test_unary_minus
    assert_sql '-1', SQL::Statement::UnaryMinus.new(SQL::Statement::Integer.new(1))
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
    assert_sql "DATE '2008-07-01'", SQL::Statement::Date.new(Date.new(2008, 7, 1))
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
