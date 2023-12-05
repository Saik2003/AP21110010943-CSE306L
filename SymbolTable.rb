class Token
  attr_reader :type, :value

  def initialize(type, value)
    @type = type
    @value = value
  end
end

class SymbolTable
  def initialize
    @table = {}
  end

  def add_entry(name, type)
    @table[name] = type
  end

  def get_table
    @table
  end
end

# Sample output
tokens = [
  Token.new(:OPERATOR, '()'),
  Token.new(:NUMBER, '3'),
  Token.new(:OPERATOR, '+'),
  Token.new(:NUMBER, '5'),
  Token.new(:OPERATOR, ')'),
  Token.new(:OPERATOR, '*'),
  Token.new(:NUMBER, '2'),
  Token.new(:KEYWORD, 'def'),
  Token.new(:IDENTIFIER, 'example_method'),
  Token.new(:KEYWORD, 'end'),
  Token.new(:IDENTIFIER, 'variable1'),
  Token.new(:OPERATOR, '='),
  Token.new(:NUMBER, '10'),
  Token.new(:IDENTIFIER, 'variable2'),
  Token.new(:OPERATOR, '='),
  Token.new(:NUMBER, '20')
]

# Create a symbol table
symbol_table = SymbolTable.new

# Iterate over tokens and add identifiers to the symbol table
tokens.each do |token|
  if token.type == :IDENTIFIER
    symbol_table.add_entry(token.value, token.type)
  end
end

# Print the symbol table as a table
puts "Symbol Table:"
puts "+----------------+------------+"
puts "| Identifier     |    Type    |"
puts "+----------------+------------+"
symbol_table.get_table.each do |name, type|
  printf("| %-14s | %-10s |\n", name, type)
end
puts "+----------------+------------+"
