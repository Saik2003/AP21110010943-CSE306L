class Token
    attr_reader :type, :value, :position
  
    def initialize(type, value, position)
      @type = type
      @value = value
      @position = position
    end
  end
  
  class SyntaxAnalyzer
    def initialize(tokens)
      @tokens = tokens
      @current_token_index = 0
    end
  
    def analyze
      parse_expression
    end
  
    private
  
    def parse_expression
      left_node = parse_term
      node = parse_expression_rest(left_node)
      node
    end
  
    def parse_expression_rest(left_node)
      token = @tokens[@current_token_index]
  
      if token&.type == :PLUS
        @current_token_index += 1
        right_node = parse_term
        node = {
          type: :PLUS,
          left: left_node,
          right: right_node,
          position: token.position
        }
        node = parse_expression_rest(node)
        return node
      else
        return left_node
      end
    end
  
    def parse_term
      left_node = parse_factor
      node = parse_term_rest(left_node)
      node
    end
  
    def parse_term_rest(left_node)
      token = @tokens[@current_token_index]
  
      if token&.type == :MULTIPLY
        @current_token_index += 1
        right_node = parse_factor
        node = {
          type: :MULTIPLY,
          left: left_node,
          right: right_node,
          position: token.position
        }
        node = parse_term_rest(node)
        return node
      else
        return left_node
      end
    end
  
    def parse_factor
      token = @tokens[@current_token_index]
      @current_token_index += 1
  
      case token&.type
      when :LPAREN
        node = parse_expression
        if @tokens[@current_token_index]&.type == :RPAREN
          @current_token_index += 1
          return {
            type: :PARENTHESIS,
            expression: node,
            position: token.position
          }
        else
          raise SyntaxError, "Expected closing parenthesis ')' at position #{token.position}"
        end
      when :NUMBER
        return {
          type: :NUMBER,
          value: token.value,
          position: token.position
        }
      else
        raise SyntaxError, "Unexpected token '#{token.value}' at position #{token.position}"
      end
    end
  end
  
  # Sample tokens representing an arithmetic expression: (3 + 5) * 2
  tokens = [
    Token.new(:LPAREN, '(', 1),
    Token.new(:NUMBER, '3', 2),
    Token.new(:PLUS, '+', 4),
    Token.new(:NUMBER, '5', 6),
    Token.new(:RPAREN, ')', 7),
    Token.new(:MULTIPLY, '*', 9),
    Token.new(:NUMBER, '2', 11),
  ]
  
  syntax_analyzer = SyntaxAnalyzer.new(tokens)
  begin
    syntax_tree = syntax_analyzer.analyze
    puts "Syntax analysis completed without errors. \nSyntax Tree:"
    puts syntax_tree
  rescue SyntaxError => e
    puts "Syntax error: #{e.message}"
  end
  