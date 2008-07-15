require File.dirname(__FILE__) + '/../lib/sql'
require File.dirname(__FILE__) + '/../lib/sql/parser.racc.rb'
require 'test/unit'

class TestParser < Test::Unit::TestCase
  def setup
    @parser = SQL::Parser.new
  end

  def test_date
    assert_sql "DATE '2008-07-11'", 'DATE "2008-07-11"'
    assert_understands "DATE '2008-07-11'"
  end

  def test_string
    assert_sql "'abc'", '"abc"'
    assert_understands "'abc'"
  end

  def test_signed_float
    # Positives
    assert_sql '+1', '+1.'
    assert_sql '+0.1', '+.1'

    assert_understands '+0.1'
    assert_understands '+1.0'
    assert_understands '+1.1'
    assert_understands '+10.1'

    # Negatives
    assert_sql '-1', '-1.'
    assert_sql '-0.1', '-.1'

    assert_understands '-0.1'
    assert_understands '-1.0'
    assert_understands '-1.1'
    assert_understands '-10.1'
  end

  def test_unsigned_float
    assert_sql '1', '1.'
    assert_sql '0.1', '.1'

    assert_understands '0.1'
    assert_understands '1.0'
    assert_understands '1.1'
    assert_understands '10.1'
  end

  def test_signed_integer
    assert_understands '+1'
    assert_understands '-1'
  end

  def test_unsigned_integer
    assert_understands '1'
    assert_understands '10'
  end

  private

  def assert_sql(expected, given)
    assert_equal expected, @parser.scan_str(given).to_sql
  end

  def assert_understands(sql)
    assert_sql(sql, sql)
  end
end
