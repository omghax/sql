class SQL::Parser

macro
  DIGIT   [0-9]
  UINT    {DIGIT}+
  BLANK   \s+

rule
# [:state]  pattern     [actions]

# literals
            \"[^"]*\"   { [:character_string_literal, text[1..-2]] }
            \'[^']*\'   { [:character_string_literal, text[1..-2]] }

            {UINT}      { [:unsigned_integer, text.to_i] }

# skip
            {BLANK}     # no action

# tokens
            \+          { [:plus_sign, text] }
            \-          { [:minus_sign, text] }
            \.          { [:period, text] }
