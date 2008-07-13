require File.dirname(__FILE__) + '/sql/statement'
require File.dirname(__FILE__) + '/sql/sql_visitor'

module SQL
  module VERSION # :nodoc:
    MAJOR = 0
    MINOR = 0
    TINY  = 1

    STRING = [MAJOR, MINOR, TINY].join('.')
  end
end
