class SQL::Parser

macro
  DIGIT   [0-9]
  UINT    {DIGIT}+
  BLANK   \s+

  YEARS   {UINT}
  MONTHS  {UINT}
  DAYS    {UINT}
  DATE    {YEARS}-{MONTHS}-{DAYS}

  IDENT   \w+

rule
# [:state]  pattern     [actions]

# literals
            \"{DATE}\"  { [:date_string, Date.parse(text)] }
            \'{DATE}\'  { [:date_string, Date.parse(text)] }

            \"[^"]*\"   { [:character_string_literal, text[1..-2]] }
            \'[^']*\'   { [:character_string_literal, text[1..-2]] }

            {UINT}      { [:unsigned_integer, text.to_i] }

# skip
            {BLANK}     # no action

# keywords
            SELECT      { [:SELECT, text] }
            DATE        { [:DATE, text] }
            AS          { [:AS, text] }
            FROM        { [:FROM, text] }
            WHERE       { [:WHERE, text] }
            BETWEEN     { [:BETWEEN, text] }
            AND         { [:AND, text] }
            NOT         { [:NOT, text] }
            INNER       { [:INNER, text] }
            IN          { [:IN, text] }
            OR          { [:OR, text] }
            LIKE        { [:LIKE, text] }
            IS          { [:IS, text] }
            NULL        { [:NULL, text] }
            COUNT       { [:COUNT, text] }
            AVG         { [:AVG, text] }
            MAX         { [:MAX, text] }
            MIN         { [:MIN, text] }
            SUM         { [:SUM, text] }
            GROUP       { [:GROUP, text] }
            BY          { [:BY, text] }
            HAVING      { [:HAVING, text] }
            CROSS       { [:CROSS, text] }
            JOIN        { [:JOIN, text] }
            ON          { [:ON, text] }
            LEFT        { [:LEFT, text] }
            OUTER       { [:OUTER, text] }
            RIGHT       { [:RIGHT, text] }

# tokens
            <>          { [:not_equals_operator, text] }
            !=          { [:not_equals_operator, text] }
            =           { [:equals_operator, text] }
            <=          { [:less_than_or_equals_operator, text] }
            <           { [:less_than_operator, text] }
            >=          { [:greater_than_or_equals_operator, text] }
            >           { [:greater_than_operator, text] }

            \(          { [:left_paren, text] }
            \)          { [:right_paren, text] }
            \*          { [:asterisk, text] }
            \/          { [:solidus, text] }
            \+          { [:plus_sign, text] }
            \-          { [:minus_sign, text] }
            \.          { [:period, text] }
            ,           { [:comma, text] }

# identifier
            {IDENT}     { [:identifier, text] }

---- header ----
require 'date'
