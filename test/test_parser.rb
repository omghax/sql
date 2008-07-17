require File.dirname(__FILE__) + '/../lib/sql'
require 'test/unit'

class TestParser < Test::Unit::TestCase
  def test_having
    assert_understands 'SELECT * FROM users HAVING id = 1'
  end

  def test_group_by
    assert_understands 'SELECT * FROM users GROUP BY name'
    assert_understands 'SELECT * FROM users GROUP BY users.name'
    assert_understands 'SELECT * FROM users GROUP BY name, id'
    assert_understands 'SELECT * FROM users GROUP BY users.name, users.id'
  end

  def test_or
    assert_understands 'SELECT * FROM users WHERE (id = 1 OR age = 18)'
  end

  def test_and
    assert_understands 'SELECT * FROM users WHERE (id = 1 AND age = 18)'
  end

  def test_not
    assert_sql 'SELECT * FROM users WHERE id <> 1', 'SELECT * FROM users WHERE NOT id = 1'
    assert_sql 'SELECT * FROM users WHERE id NOT IN (1, 2, 3)', 'SELECT * FROM users WHERE NOT id IN (1, 2, 3)'
    assert_sql 'SELECT * FROM users WHERE id NOT BETWEEN 1 AND 3', 'SELECT * FROM users WHERE NOT id BETWEEN 1 AND 3'
    assert_sql "SELECT * FROM users WHERE name NOT LIKE 'A%'", "SELECT * FROM users WHERE NOT name LIKE 'A%'"
  end

  def test_is_not_null
    assert_understands 'SELECT * FROM users WHERE deleted_at IS NOT NULL'
  end

  def test_is_null
    assert_understands 'SELECT * FROM users WHERE deleted_at IS NULL'
  end

  def test_not_like
    assert_understands "SELECT * FROM users WHERE name NOT LIKE 'Joe%'"
  end

  def test_like
    assert_understands "SELECT * FROM users WHERE name LIKE 'Joe%'"
  end

  def test_not_in
    assert_understands 'SELECT * FROM users WHERE id NOT IN (1, 2, 3)'
  end

  def test_in
    assert_understands 'SELECT * FROM users WHERE id IN (1, 2, 3)'
  end

  def test_not_between
    assert_understands 'SELECT * FROM users WHERE id NOT BETWEEN 1 AND 3'
  end

  def test_between
    assert_understands 'SELECT * FROM users WHERE id BETWEEN 1 AND 3'
  end

  def test_gte
    assert_understands 'SELECT * FROM users WHERE id >= 1'
  end

  def test_lte
    assert_understands 'SELECT * FROM users WHERE id <= 1'
  end

  def test_gt
    assert_understands 'SELECT * FROM users WHERE id > 1'
  end

  def test_lt
    assert_understands 'SELECT * FROM users WHERE id < 1'
  end

  def test_not_equals
    assert_sql 'SELECT * FROM users WHERE id <> 1', 'SELECT * FROM users WHERE id != 1'
    assert_understands 'SELECT * FROM users WHERE id <> 1'
  end

  def test_equals
    assert_understands 'SELECT * FROM users WHERE id = 1'
  end

  def test_where_clause
    assert_understands 'SELECT * FROM users WHERE 1 = 1'
  end

  def test_sum
    assert_understands 'SELECT SUM(messages_count) FROM users'
  end

  def test_min
    assert_understands 'SELECT MIN(age) FROM users'
  end

  def test_max
    assert_understands 'SELECT MAX(age) FROM users'
  end

  def test_avg
    assert_understands 'SELECT AVG(age) FROM users'
  end

  def test_count
    assert_understands 'SELECT COUNT(*) FROM users'
    assert_understands 'SELECT COUNT(id) FROM users'
  end

  def test_from_clause
    assert_understands 'SELECT 1 FROM users'
    assert_understands 'SELECT id FROM users'
    assert_understands 'SELECT users.id FROM users'
    assert_understands 'SELECT * FROM users'
  end

  def test_select_list
    assert_understands 'SELECT 1, 2'
    assert_understands 'SELECT (1 + 1) AS x, (2 + 2) AS y'
    assert_understands 'SELECT id, name'
    assert_understands 'SELECT (age * 2) AS double_age, first_name AS name'
  end

  def test_as
    assert_understands 'SELECT 1 AS x'
    assert_understands 'SELECT (1 + 1) AS y'
  end

  def test_parentheses
    assert_sql 'SELECT ((1 + 2) * ((3 - 4) / 5))', 'SELECT (1 + 2) * (3 - 4) / 5'
  end

  def test_order_of_operations
    assert_sql 'SELECT (1 + ((2 * 3) - (4 / 5)))', 'SELECT 1 + 2 * 3 - 4 / 5'
  end

  def test_numeric_value_expression
    assert_understands 'SELECT (1 * 2)'
    assert_understands 'SELECT (1 / 2)'
    assert_understands 'SELECT (1 + 2)'
    assert_understands 'SELECT (1 - 2)'
  end

  def test_date
    assert_sql "SELECT DATE '2008-07-11'", 'SELECT DATE "2008-07-11"'
    assert_understands "SELECT DATE '2008-07-11'"
  end

  def test_string
    assert_sql "SELECT 'abc'", 'SELECT "abc"'
    assert_understands "SELECT 'abc'"
  end

  def test_signed_float
    # Positives
    assert_sql 'SELECT +1', 'SELECT +1.'
    assert_sql 'SELECT +0.1', 'SELECT +.1'

    assert_understands 'SELECT +0.1'
    assert_understands 'SELECT +1.0'
    assert_understands 'SELECT +1.1'
    assert_understands 'SELECT +10.1'

    # Negatives
    assert_sql 'SELECT -1', 'SELECT -1.'
    assert_sql 'SELECT -0.1', 'SELECT -.1'

    assert_understands 'SELECT -0.1'
    assert_understands 'SELECT -1.0'
    assert_understands 'SELECT -1.1'
    assert_understands 'SELECT -10.1'
  end

  def test_unsigned_float
    assert_sql 'SELECT 1', 'SELECT 1.'
    assert_sql 'SELECT 0.1', 'SELECT .1'

    assert_understands 'SELECT 0.1'
    assert_understands 'SELECT 1.0'
    assert_understands 'SELECT 1.1'
    assert_understands 'SELECT 10.1'
  end

  def test_signed_integer
    assert_understands 'SELECT +1'
    assert_understands 'SELECT -1'
  end

  def test_unsigned_integer
    assert_understands 'SELECT 1'
    assert_understands 'SELECT 10'
  end

  private

  def assert_sql(expected, given)
    assert_equal expected, SQL::Parser.parse(given).to_sql
  end

  def assert_understands(sql)
    assert_sql(sql, sql)
  end
end
