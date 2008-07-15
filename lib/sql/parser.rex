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

# tokens
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
