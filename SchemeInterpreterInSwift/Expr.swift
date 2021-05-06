import Foundation

protocol ExprVisitor {
    func visitSymbolExpr(_ expr: Expr.Symbol) -> Any?
    func visitLiteralExpr(_ expr: Expr.Literal) -> Any?
    func visitSListExpr(_ expr: Expr.SList) -> Any?
}

class Expr {

    func accept<V: ExprVisitor>(visitor: V) -> Any? {
        fatalError()
    }

    class Symbol: Expr {
        let value: Any?

        init(value: Any?) {
            self.value = value
        }

        override func accept<V: ExprVisitor>(visitor: V) -> Any? {
            return visitor.visitSymbolExpr(self)
        }
    }

    class Literal: Expr {
        let value: Any?

        init(value: Any?) {
            self.value = value
        }

        override func accept<V: ExprVisitor>(visitor: V) -> Any? {
            return visitor.visitLiteralExpr(self)
        }

    }

    class SList: Expr {
       final var expression = Array<Expr>()

        init(expression: Array<Expr>) {
          self.expression = expression
        }

        override func accept<V: ExprVisitor>(visitor: V) -> Any? {
            return visitor.visitSListExpr(self)
        }
    }
}