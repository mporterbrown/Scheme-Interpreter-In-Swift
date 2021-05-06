import Foundation

final class Scanner {
    private let source: String
    var tokens = [Token]()

    private var start: String.Index
    private var current: String.Index
    private var line = 1

    init(source: String) {
        self.source = source

        start = source.startIndex
        current = start
    }

    func scanTokens() -> [Token] {
        while isAtEnd() == false {
            start = current
            scanToken()
        }

        let finalToken = Token(type: .EOF, lexeme: "", literal: nil, line: line)
        tokens.append(finalToken)

        return tokens
    }

    private func isAtEnd() -> Bool {
        return current == source.endIndex
    }

    func scanToken() {
        let c = advance()
        switch c {
            case "(":
            addToken(type: .LEFTPAREN)

            case ")":
            addToken(type: .RIGHTPAREN)

            case "#" where match("t"):
            addToken(type: .TRUE1)

            case "#" where match("f"):
            
            addToken(type: .FALSE1)

            case "n" where match("i") && match("l"):
            
            addToken(type: .NULL)

            case ";":
            while peek() != "\n" && isAtEnd() == false {
                _ = advance()
            }

            case " ", "\r", "\t":
            // Ingore the whitespace
            break

            case "\n": 
            line += 1

            case "\"":
            string()

            case "=":
            addToken(type: .SYMBOL)
          
            case "-" where isDigit(peek()):
            number()
            

            // case _ where isDigit(c):
            //     number()

            // case _ where (isAlpha(c) || isOperator(c)):
            //     identifier()

            default:

            if isDigit(c) {
              number()
              } else if (isAlpha(c) || isOperator(c)){
                  identifier()
                  } else {
                    fatalError("Unexpected character. '\(c)'")
                  }    
              }
          }

          private func identifier() {
            while (isAlphaNumeric(peek()) || isOperator(peek())) {
                _ = advance()
            }
            addToken(type: .SYMBOL)
            // See if the identifier is a reserver word
            // let text = String(source[start ..< current])

            // let type = Scanner.keywords[text] ?? .identifier
            // addToken(type: type)
        }

        private func number() {
            while isDigit(peek()) {
                _ = advance()
            }

            // Look for a fractional part.
            if peek() == "." && isDigit(peekNext()) {
                // Consume the "."
                _ = advance()
            }

            while isDigit(peek()) {
                _ = advance()
            }

            let numberString = String(source[start ..< current])
            let number = Double(numberString)!
            addToken(type: .NUMBER, literal: number)
        }

        private func string() {
            while peek() != "\"" && isAtEnd() == false {
                if peek() == "\n" {
                    line += 1
                }
                _ = advance()
            }

            // Unterminated string
            if isAtEnd() {
                fatalError("String needs to be Terminated")
            }

            // The closing ".
            _ = advance()

            // Trim the surrounding quotes.
            let inside = source.index(after: start)
            let beforeEnd = source.index(before: current)
            let value = String(source[inside ..< beforeEnd])
            addToken(type: .STRING, literal: value)
        }

        private func match(_ expected: Character) -> Bool {
            if(isAtEnd()){
              return false
          }
          if(source[current] != expected){
              return false;
          }

          current = source.index(after: current)
          return true
      }

      private func peek() -> Character {
        if (isAtEnd()) { 
          return "\0" 
      }
      return source[current]
  }

  private func peekNext() -> Character {
      let next = source.index(after: current)
      if (next != source.endIndex) { 
          return "\0" 
      }

      
      guard next != source.endIndex else { return "\0" }

      return source[next]
  }

  private func isDigit(_ c: Character) -> Bool {
    let digits = CharacterSet.decimalDigits
    // FIXME: Robustness
    return digits.contains(String(c).unicodeScalars.first!)
}

private func isAlpha(_ c: Character) -> Bool {
    let alpha = String(c).unicodeScalars.first!
    return CharacterSet.lowercaseLetters.contains(alpha)
    || CharacterSet.uppercaseLetters.contains(alpha)
}

private func isAlphaNumeric(_ c: Character) -> Bool {
    return isAlpha(c) || isDigit(c)
}

private func isOperator(_ c: Character) -> Bool {
    return (c == "+") || (c == "-") ||
    (c == "*") || (c == "/") ||
    (c == ">") || (c == "<") || (c == "!")
}

private func advance() -> Character {
    let prev = current
    current = source.index(after: current)
    let char = source[prev]
    return char
}

private func addToken(type: TokenType, literal: Any? = nil) {
    let text = String(source[start ..< current])
    let token = Token(type: type, lexeme: text, literal: literal, line: line)
    tokens.append(token)
}
}

