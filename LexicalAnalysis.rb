class String
    def isspace
      self =~ /^\s+$/
    end
  end
  
  RubyKeywords = %w[
  begin end if unless else elsif case when while until for in do
  module class def defined? alias undef super self
  true false nil and or not
  rescue ensure retry raise throw catch fail
  public protected private
  attr_accessor attr_reader attr_writer attr
  break next redo return
  true false nil
]
  
  class Lexer
    def initialize(source_code)
      @source_code = source_code
      @current_position = 0
      @current_token = nil
    end
  
    def next_token
        while @current_position < @source_code.length
          character = @source_code[@current_position]
          @current_position += 1
      
          if character.isspace
            next
          elsif character.match?(/[[:alpha:]_]/)
            token = lex_identifier(character)
            return token
          elsif character.match?(/[[:digit:]]/)
            token = lex_number(character)
            return token
          elsif ['+', '-', '*', '/', '%', '(', ')', ','].include?(character)
            token = Token.new(TokenType::OPERATOR, character)
            return token
          elsif character == '='
            token = Token.new(TokenType::ASSIGNMENT_OPERATOR, character)
            return token
          elsif character == '@'
            return lex_identifier(character)
          elsif character == '#'
            skip_comments
          else
            raise LexicalError, "Unexpected character: #{character}"
          end
        end
      
        nil
      end
    
  
      def lex_identifier(first_character)
        identifier = first_character
        while @current_position < @source_code.length && @source_code[@current_position].match?(/[[:alnum:]_@]/)
          identifier += @source_code[@current_position]
          @current_position += 1
        end
      
        # Check if the identifier is a keyword
        if RubyKeywords.include?(identifier)
          token = Token.new(TokenType::KEYWORD, identifier)
        else
          token = Token.new(TokenType::IDENTIFIER, identifier)
        end
      
        token
      end
  
    def lex_number(first_character)
      number = first_character
      while @current_position < @source_code.length && @source_code[@current_position].match?(/\d/)
        number += @source_code[@current_position]
        @current_position += 1
      end
    
      Token.new(TokenType::NUMBER, number)
    end
    
    def lex_string
      string = ''
      delimiter = @source_code[@current_position]
      @current_position += 1
    
      while @current_position < @source_code.length && @source_code[@current_position] != delimiter
        string += @source_code[@current_position]
        @current_position += 1
      end
    
      @current_position += 1
    
      Token.new(TokenType::STRING, string)
    end
    
    def skip_comments
      while @current_position < @source_code.length && @source_code[@current_position] != "\n"
        @current_position += 1
      end
    
      @current_position += 1
    end
    
    def lex_keyword
      keyword = ''
      while @current_position < @source_code.length && @source_code[@current_position].match?(/[[:alnum:]_]/)
        keyword += @source_code[@current_position]
        @current_position += 1
      end
    
      if RubyKeywords.include?(keyword)
        Token.new(TokenType::KEYWORD, keyword)
      else
        Token.new(TokenType::IDENTIFIER, keyword)
      end
    end
  end
  
  class TokenType
    IDENTIFIER = :IDENTIFIER
    OPERATOR = :OPERATOR
    ASSIGNMENT_OPERATOR = :ASSIGNMENT_OPERATOR
    NUMBER = :NUMBER
    STRING = :STRING
    KEYWORD = :KEYWORD
  end
  
  
  class Token
    def initialize(type, value)
      @type = type
      @value = value
    end
  
    def type
      @type
    end
  
    def value
      @value
    end
  
    def to_s
      "Token(type = #{@type}, value -> '#{@value}')"
    end
  end

  
  class LexicalError < StandardError; end
  
  def main
    source_code = <<~CODE
      (3 + 10) * 2
      # This is a comment.
      def example_method
        @variable1 = 46
        @variable3 = 10
        # Method body
      end
    CODE
  
    lexer = Lexer.new(source_code)
  
    token = lexer.next_token
    while !token.nil?
      puts token
      token = lexer.next_token
    end
  end
  
  if __FILE__ == $0
    main
  end
  