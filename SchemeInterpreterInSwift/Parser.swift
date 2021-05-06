import Foundation

final class Parser {
    enum Error: Swift.Error {
        case parseFailure
    }

    private var tokens: Array<Token>
    private var current = 0

    init(tokens: Array<Token>) {
        self.tokens = tokens
    }

    func parse() -> Array<Expr?> {
        var statements = Array<Expr?>()

        while !isAtEnd() {    
          if let sexp = sexp(){
            statements.append(sexp)
        }              
    }
    return statements
}

private func sexp() -> Expr? {

    if match(.NUMBER, .STRING, .TRUE1, .FALSE1, .NULL) {
        
        return Expr.Literal(value: previous().literal)
    }

    if match(.SYMBOL) {  
        return Expr.Symbol(value: previous().lexeme)
    }

    if match(.LEFTPAREN) {
        var sList = Array<Expr>()

        while (!check(.RIGHTPAREN) && !isAtEnd()) { 
          if let sexp = sexp(){
            sList.append(sexp) 
        }              
    }
    consume(.RIGHTPAREN)
    return Expr.SList(expression: sList)
}
return nil
}

func match(_ types: [TokenType]) -> Bool {
    for type in types {
        if check(type) {
            _ = advance()
            return true
        }
    }
    return false
}

func match(_ types: TokenType...) -> Bool {
    return match(types)
}

func check(_ tokenType: TokenType) -> Bool {
    if isAtEnd() {
        return false
    }
    return peek().type == tokenType
}

func advance() -> Token {
    if !isAtEnd() {
        current += 1
    }
    return previous()
}

func isAtEnd() -> Bool {
    return peek().type == .EOF
}

func peek() -> Token {
    return tokens[current]
}

func previous() -> Token {
    return tokens[current - 1]
}


func consume(_ type: TokenType) -> Token? {
    if check(type) {
     return advance()
 }
 return nil
}
}

extension Parser {
    func error(token: Token, message: String) -> Error {        
        return Error.parseFailure
    }
}
