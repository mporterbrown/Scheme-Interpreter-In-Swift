import Foundation

struct Token: CustomStringConvertible {

  let type: TokenType
  let lexeme: String
  let literal: Any?
  let line: Int
  
  init(type: TokenType, lexeme: String, literal: Any?, line: Int) {
    self.type = type
    self.lexeme = lexeme 
    self.literal = literal
    self.line = line
  }

  var description: String  {
    let literalUnwrap: String
    if let literal = literal {
      literalUnwrap = "\(literal)"
      } else {
        literalUnwrap = "nil"
      }
      return "\(type) \(lexeme) \(literalUnwrap)"
    }
  }

  //Add to presentation about elaborate ENUM
  enum TokenType : CustomStringConvertible{
    case LEFTPAREN 
    case RIGHTPAREN 
    case SYMBOL 
    case STRING 
    case NUMBER 
    case TRUE1
    case FALSE1 
    case NULL 
    case EOF

    var description : String { 
      switch self {
        // Use Internationalization, as appropriate.
        case .LEFTPAREN: return "LEFT_PAREN"
        case .RIGHTPAREN: return "RIGHT_PAREN"
        case .SYMBOL: return "SYMBOL"
        case .STRING: return "STRING"
        case .NUMBER: return "NUMBER"
        case .TRUE1: return "TRUE"
        case .FALSE1: return "FALSE"
        case .NULL: return "NULL"
        case .EOF: return "EOF"
      }
    }
  }


  extension DefaultStringInterpolation {
    mutating func appendInterpolation<T>(optional: T?) {
      appendInterpolation(String(describing: optional))
    }
  }