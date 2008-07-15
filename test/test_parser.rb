require File.dirname(__FILE__) + '/../lib/sql'
require File.dirname(__FILE__) + '/../lib/sql/parser.racc.rb'
require 'test/unit'

class TestParser < Test::Unit::TestCase
  def setup
    @parser = SQL::Parser.new
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
    assert_equal expected, @parser.scan_str(given).to_sql
  end

  def assert_understands(sql)
    assert_sql(sql, sql)
  end
end
