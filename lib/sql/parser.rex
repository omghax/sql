class SQL::Parser

macro
  DIGIT   [0-9]
  UINT    {DIGIT}+
  BLANK   \s+

  YEARS   {UINT}
  MONTHS  {UINT}
  DAYS    {UINT}
  DATE    {YEARS}-{MONTHS}-{DAYS}

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
            DATE        { [:DATE, text] }

# tokens
            \+          { [:plus_sign, text] }
            \-          { [:minus_sign, text] }
            \.          { [:period, text] }

---- header ----
require 'date'
