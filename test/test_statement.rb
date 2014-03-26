require File.dirname(File.expand_path(__FILE__)) + '/../lib/sql'

gem 'minitest', "4.7.5"
require 'test/unit'

class TestStatement < Test::Unit::TestCase
  def test_direct_select
    assert_sql 'SELECT * FROM `users` ORDER BY `name`', SQL::Statement::DirectSelect.new(select(all, tblx(from(tbl('users')))), SQL::Statement::OrderBy.new(col('name')))
  end

  def test_order_by
    assert_sql 'ORDER BY `name`', SQL::Statement::OrderBy.new(col('name'))
  end

  def test_subquery
    assert_sql '(SELECT 1)', SQL::Statement::Subquery.new(select(int(1)))
  end

  def test_select
    assert_sql 'SELECT 1', select(int(1))
    assert_sql 'SELECT * FROM `users`', select(all, tblx(from(tbl('users'))))
  end

  def test_select_list
    assert_sql '`id`', slist(col('id'))
    assert_sql '`id`, `name`', slist([col('id'), col('name')])
  end

  def test_distinct
    assert_sql 'DISTINCT(`username`)', distinct(col('username'))
  end

  def test_all
    assert_sql '*', all
  end

  def test_table_expression
    assert_sql 'FROM `users` WHERE `id` = 1 GROUP BY `name`', tblx(from(tbl('users')), where(equals(col('id'), int(1))), group_by(col('name')))
  end

  def test_from_clause
    assert_sql 'FROM `users`', from(tbl('users'))
  end

  def test_full_outer_join
    assert_sql '`t1` FULL OUTER JOIN `t2` ON `t1`.`a` = `t2`.`a`', SQL::Statement::FullOuterJoin.new(tbl('t1'), tbl('t2'), SQL::Statement::On.new(equals(qcol(tbl('t1'), col('a')), qcol(tbl('t2'), col('a')))))
    assert_sql '`t1` FULL OUTER JOIN `t2` USING (`a`)', SQL::Statement::FullOuterJoin.new(tbl('t1'), tbl('t2'), SQL::Statement::Using.new(col('a')))
  end

  def test_full_join
    assert_sql '`t1` FULL JOIN `t2` ON `t1`.`a` = `t2`.`a`', SQL::Statement::FullJoin.new(tbl('t1'), tbl('t2'), SQL::Statement::On.new(equals(qcol(tbl('t1'), col('a')), qcol(tbl('t2'), col('a')))))
  end

  def test_right_outer_join
    assert_sql '`t1` RIGHT OUTER JOIN `t2` ON `t1`.`a` = `t2`.`a`', SQL::Statement::RightOuterJoin.new(tbl('t1'), tbl('t2'), SQL::Statement::On.new(equals(qcol(tbl('t1'), col('a')), qcol(tbl('t2'), col('a')))))
  end

  def test_right_join
    assert_sql '`t1` RIGHT JOIN `t2` ON `t1`.`a` = `t2`.`a`', SQL::Statement::RightJoin.new(tbl('t1'), tbl('t2'), SQL::Statement::On.new(equals(qcol(tbl('t1'), col('a')), qcol(tbl('t2'), col('a')))))
  end

  def test_left_outer_join
    assert_sql '`t1` LEFT OUTER JOIN `t2` ON `t1`.`a` = `t2`.`a`', SQL::Statement::LeftOuterJoin.new(tbl('t1'), tbl('t2'), SQL::Statement::On.new(equals(qcol(tbl('t1'), col('a')), qcol(tbl('t2'), col('a')))))
  end

  def test_left_join
    assert_sql '`t1` LEFT JOIN `t2` ON `t1`.`a` = `t2`.`a`', SQL::Statement::LeftJoin.new(tbl('t1'), tbl('t2'), SQL::Statement::On.new(equals(qcol(tbl('t1'), col('a')), qcol(tbl('t2'), col('a')))))
  end

  def test_inner_join
    assert_sql '`t1` INNER JOIN `t2` ON `t1`.`a` = `t2`.`a`', SQL::Statement::InnerJoin.new(tbl('t1'), tbl('t2'), SQL::Statement::On.new(equals(qcol(tbl('t1'), col('a')), qcol(tbl('t2'), col('a')))))
  end

  def test_cross_join
    assert_sql '`t1` CROSS JOIN `t2`', SQL::Statement::CrossJoin.new(tbl('t1'), tbl('t2'))
    assert_sql '`t1` CROSS JOIN `t2` CROSS JOIN `t3`', SQL::Statement::CrossJoin.new(SQL::Statement::CrossJoin.new(tbl('t1'), tbl('t2')), tbl('t3'))
  end

  def test_order_clause
    assert_sql 'ORDER BY `name` DESC', SQL::Statement::OrderClause.new(SQL::Statement::Descending.new(col('name')))
    assert_sql 'ORDER BY `id` ASC, `name` DESC', SQL::Statement::OrderClause.new([SQL::Statement::Ascending.new(col('id')), SQL::Statement::Descending.new(col('name'))])
  end

  def test_having_clause
    assert_sql 'HAVING `id` = 1', SQL::Statement::HavingClause.new(equals(col('id'), int(1)))
  end

  def test_group_by_clause
    assert_sql 'GROUP BY `name`', group_by(col('name'))
    assert_sql 'GROUP BY `name`, `status`', group_by([col('name'), col('status')])
  end

  def test_where_clause
    assert_sql 'WHERE 1 = 1', where(equals(int(1), int(1)))
  end

  def test_or
    assert_sql '(FALSE OR FALSE)', SQL::Statement::Or.new(SQL::Statement::False.new, SQL::Statement::False.new)
  end

  def test_and
    assert_sql '(TRUE AND TRUE)', SQL::Statement::And.new(SQL::Statement::True.new, SQL::Statement::True.new)
  end

  def test_is_not_null
    assert_sql '1 IS NOT NULL', SQL::Statement::Not.new(SQL::Statement::Is.new(int(1), SQL::Statement::Null.new))
  end

  def test_is_null
    assert_sql '1 IS NULL', SQL::Statement::Is.new(int(1), SQL::Statement::Null.new)
  end

  def test_not_like
    assert_sql "'hello' NOT LIKE 'h%'", SQL::Statement::Not.new(SQL::Statement::Like.new(str('hello'), str('h%')))
  end

  def test_like
    assert_sql "'hello' LIKE 'h%'", SQL::Statement::Like.new(str('hello'), str('h%'))
  end

  def test_not_in
    assert_sql '1 NOT IN (1, 2, 3)', SQL::Statement::Not.new(SQL::Statement::In.new(int(1), SQL::Statement::InValueList.new([int(1), int(2), int(3)])))
  end

  def test_in
    assert_sql '1 IN (1, 2, 3)', SQL::Statement::In.new(int(1), SQL::Statement::InValueList.new([int(1), int(2), int(3)]))
  end

  def test_not_between
    assert_sql '2 NOT BETWEEN 1 AND 3', SQL::Statement::Not.new(SQL::Statement::Between.new(int(2), int(1), int(3)))
  end

  def test_between
    assert_sql '2 BETWEEN 1 AND 3', SQL::Statement::Between.new(int(2), int(1), int(3))
  end

  def test_gte
    assert_sql '1 >= 1', SQL::Statement::GreaterOrEquals.new(int(1), int(1))
  end

  def test_lte
    assert_sql '1 <= 1', SQL::Statement::LessOrEquals.new(int(1), int(1))
  end

  def test_gt
    assert_sql '1 > 1', SQL::Statement::Greater.new(int(1), int(1))
  end

  def test_lt
    assert_sql '1 < 1', SQL::Statement::Less.new(int(1), int(1))
  end

  def test_not_equals
    assert_sql '1 <> 1', SQL::Statement::Not.new(equals(int(1), int(1)))
  end

  def test_equals
    assert_sql '1 = 1', equals(int(1), int(1))
  end

  def test_sum
    assert_sql 'SUM(`messages_count`)', SQL::Statement::Sum.new(col('messages_count'))
  end

  def test_minimum
    assert_sql 'MIN(`age`)', SQL::Statement::Minimum.new(col('age'))
  end

  def test_maximum
    assert_sql 'MAX(`age`)', SQL::Statement::Maximum.new(col('age'))
  end

  def test_average
    assert_sql 'AVG(`age`)', SQL::Statement::Average.new(col('age'))
  end

  def test_count
    assert_sql 'COUNT(*)', SQL::Statement::Count.new(all)
  end

  def test_table
    assert_sql '`users`', tbl('users')
  end

  def test_qualified_column
    assert_sql '`users`.`id`', qcol(tbl('users'), col('id'))
  end

  def test_column
    assert_sql '`id`', col('id')
  end

  def test_as
    assert_sql '1 AS `a`', SQL::Statement::As.new(int(1), col('a'))
  end

  def test_multiply
    assert_sql '(2 * 2)', SQL::Statement::Multiply.new(int(2), int(2))
  end

  def test_divide
    assert_sql '(2 / 2)', SQL::Statement::Divide.new(int(2), int(2))
  end

  def test_add
    assert_sql '(2 + 2)', SQL::Statement::Add.new(int(2), int(2))
  end

  def test_subtract
    assert_sql '(2 - 2)', SQL::Statement::Subtract.new(int(2), int(2))
  end

  def test_unary_plus
    assert_sql '+1', SQL::Statement::UnaryPlus.new(int(1))
  end

  def test_unary_minus
    assert_sql '-1', SQL::Statement::UnaryMinus.new(int(1))
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

  def test_current_user
    assert_sql 'CURRENT_USER', SQL::Statement::CurrentUser.new
  end

  def test_datetime
    assert_sql "'2008-07-01 12:34:56'", SQL::Statement::DateTime.new(Time.local(2008, 7, 1, 12, 34, 56))
  end

  def test_date
    assert_sql "DATE '2008-07-01'", SQL::Statement::Date.new(Date.new(2008, 7, 1))
  end

  def test_string
    assert_sql "'foo'", str('foo')

    # # FIXME
    # assert_sql "'O\\\'rly'", str("O'rly")
  end

  def test_approximate_float
    assert_sql '1E1', SQL::Statement::ApproximateFloat.new(int(1), int(1))
  end

  def test_float
    assert_sql '1.1', SQL::Statement::Float.new(1.1)
  end

  def test_integer
    assert_sql '1', int(1)
  end

  private

  def assert_sql(expected, ast)
    assert_equal expected, ast.to_sql
  end

  def qcol(table, column)
    SQL::Statement::QualifiedColumn.new(table, column)
  end

  def equals(left, right)
    SQL::Statement::Equals.new(left, right)
  end

  def all
    SQL::Statement::All.new
  end

  def str(value)
    SQL::Statement::String.new(value)
  end

  def int(value)
    SQL::Statement::Integer.new(value)
  end

  def col(name)
    SQL::Statement::Column.new(name)
  end

  def tbl(name)
    SQL::Statement::Table.new(name)
  end

  def distinct(col)
    SQL::Statement::Distinct.new(col)
  end

  def slist(ary)
    SQL::Statement::SelectList.new(ary)
  end

  def select(list, table_expression = nil)
    SQL::Statement::Select.new(list, table_expression)
  end

  def tblx(from_clause, where_clause = nil, group_by_clause = nil, having_clause = nil)
    SQL::Statement::TableExpression.new(from_clause, where_clause, group_by_clause, having_clause)
  end

  def from(tables)
    SQL::Statement::FromClause.new(tables)
  end

  def where(search_condition)
    SQL::Statement::WhereClause.new(search_condition)
  end

  def group_by(columns)
    SQL::Statement::GroupByClause.new(columns)
  end
end
