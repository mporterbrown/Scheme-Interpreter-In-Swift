import Foundation

class Interpreter: ExprVisitor{

    private let globals = Environment()
    private var environment: Environment

    init() {
        environment = globals
    }

    func interpret(_ expressions: Array<Expr?>) {
        do {
            for expression in expressions {
              if let expression = expression{
                try execute(expression)
              }     
            }
        } catch {
           print("error")
        }
    }

     private func evaluate(expr: Expr) -> Any? {
        return expr.accept(visitor: self)
    }

    private func execute(_ expr: Expr) {         
          let temp = expr.accept(visitor: self) 
          if temp != nil {
            print("\(">") \(temp.unsafelyUnwrapped)")
          }
    }

    func executeEnv(expression: Expr, environment: Environment) {
      let previous = self.environment
      try self.environment = environment
      execute(expression);
      self.environment = previous;
  }


    func visitLiteralExpr(_ expr: Expr.Literal) -> Any? {
        guard let value = expr.value else {
            return nil
        }
        return value
    }

     func visitSymbolExpr(_ expr: Expr.Symbol) -> Any? {
        let temp = expr.value as! String
        return environment.get(key: temp)
    }

    func firstConvert(_ expr: Expr.SList) -> Any? {
      let temp = expr.expression[0] as! Expr.Symbol
      let temp2 = temp.value as! String
      var tempArray = [Any]()
      let globalValues = globals.values
      if globalValues.index(forKey: temp2 as! String) != nil {
        var temp3 = globals.get(key: temp2 as! String) as! Procedure
   
        for i in 1..<expr.expression.count {
          tempArray.append(expr.expression[i])
        }         
        temp3.call(vars: tempArray)
        return "skip"
      } else {
        return temp2
      }  
    }

     func visitSListExpr(_ expr: Expr.SList) -> Any? {

        var arguments = [Any]()
       
        for i in 1..<expr.expression.count {          
             arguments.append(expr.expression[i])
         }

      
     
      var first: Any
        if(expr.expression[0] as! Expr is Expr.Symbol){
          first = firstConvert(expr as! Expr.SList)
        } else if (expr.expression[0] as! Expr is Expr.SList){
          let var1 = expr.expression[0] as! Expr.SList
          let var2 = evaluate(expr: var1)
          var tempArray = [Any]()
          for i in 1..<expr.expression.count {
            let input = expr.expression[i] as! Expr.Literal
            tempArray.append(input)
          }
          let var3 = var2 as! Procedure
          return var3.call(vars: tempArray)
        } else if expr.expression[0] as! Expr is Expr.Literal {
          let literalInput = expr.expression[0] as! Expr
          return evaluate(expr: literalInput)
        } else {
          return "skip"
        }
  
        
        
        switch first as! String {
          case "skip":
           break
           
          case "+":
           arguments = prepareSListExpr(tempArray: arguments)
           var lhs = arguments[0] as! Double
           for i in 1..<arguments.count {  
             let rest = arguments[i] as! Double        
             lhs += rest
           }

           return lhs
          
          case "-":
           arguments = prepareSListExpr(tempArray: arguments)
           var lhs = arguments[0] as! Double
           for i in 1..<arguments.count {  
             let rest = arguments[i] as! Double        
             lhs -= rest
           }

           return lhs

           case "*":        
           arguments = prepareSListExpr(tempArray: arguments)  
           var lhs = arguments[0] as! Double
           for i in 1..<arguments.count {  
             let rest = arguments[i] as! Double        
             lhs *= rest
           }

           return lhs

           case "/":
           arguments = prepareSListExpr(tempArray: arguments)
           var lhs = arguments[0] as! Double
           for i in 1..<arguments.count {  
             let rest = arguments[i] as! Double 
             if i != 0 && rest == 0 {
               return fatalError("DIVISION BY 0")
             }   
             lhs /= rest
           }

           return lhs

           case "=":
           arguments = prepareSListExpr(tempArray: arguments)
           let lhs = arguments[0] as! Double
           let rhs = arguments[1] as! Double
           if lhs == rhs{
             return true
           } else {
             return false
           }


           case ">":
           arguments = prepareSListExpr(tempArray: arguments)
           let lhs = arguments[0] as! Double
           let rhs = arguments[1] as! Double
           if lhs > rhs{
             return true
           } else {
             return false
           }

           case "<":
           arguments = prepareSListExpr(tempArray: arguments)
           let lhs = arguments[0] as! Double
           let rhs = arguments[1] as! Double
           if lhs < rhs{
             return true
           } else {
             return false
           }

           case "random":
           arguments = prepareSListExpr(tempArray: arguments)
           let lhs = arguments[0] as! Double
           let returnTemp =  Double.random(in: 1..<lhs)
           return Int(returnTemp)
         
           case "expt":
           arguments = prepareSListExpr(tempArray: arguments)
           let lhs = arguments[0] as! Double
           let rhs = arguments[1] as! Double
           let result = pow(lhs, rhs)

           if arguments.count > 2 {
             return fatalError("EXPT ALLOWS ONLY TWO VALUES")
           }

           case "abs":
           arguments = prepareSListExpr(tempArray: arguments)
           let value = arguments[0] as! Double
           let result = abs(value)
           if arguments.count > 1 {
             return fatalError("ABS CAN ONLY TAKE ONE VALUE")
           }

           return result

           case "sqrt":
           arguments = prepareSListExpr(tempArray: arguments)
           let value = arguments[0] as! Double
           if arguments.count > 1 {
             return fatalError("SQRT CAN ONLY TAKE ONE VALUE")
           }

           return sqrt(value)

           case "mod":
           arguments = prepareSListExpr(tempArray: arguments)
           let lhs = arguments[0] as! Double
           let rhs = arguments[1] as! Double

           if (arguments.count > 2) {
           return fatalError("MOD ONLY TAKES 2 ARGUMENTS")
           }

           return lhs.truncatingRemainder(dividingBy: rhs)

           case "sin":
           arguments = prepareSListExpr(tempArray: arguments)
           let value = arguments[0] as! Double
           if (arguments.count > 1) {
           return fatalError("SIN ONLY TAKES 1 ARGUMENT")
           }

           return sin(value)

           case "cos":
           arguments = prepareSListExpr(tempArray: arguments)
           let value = arguments[0] as! Double
           if (arguments.count > 1) {
           return fatalError("COS ONLY TAKES 1 ARGUMENT")
           }

           return cos(value)

           case "tan":
           arguments = prepareSListExpr(tempArray: arguments)
           let value = arguments[0] as! Double
           if (arguments.count > 1) {
           return fatalError("TAN ONLY TAKES 1 ARGUMENT")
           }

           return tan(value)

           case "display":
           arguments = prepareSListExpr(tempArray: arguments)
           var result: String!
           result = arguments[0] as! String
           return result

           case "and":
           arguments = prepareSListExpr(tempArray: arguments)
           for arg in arguments {
             if arg as! Bool == false {
               return false
             } else {
               return true
             }
           }

           case "or":
           arguments = prepareSListExpr(tempArray: arguments)
           for arg in arguments {
             if arg as! Bool == true {
               return true
             } else {
               return false
             }
           }

          case "set!":
          let arg1 = arguments[0] as! Expr.Symbol

          if (arguments[1] is Expr.Symbol) {
            var argReturn : Any
            let arg2 = arguments[1] as! Expr.Symbol
            argReturn = evaluate(expr: arg2) as! Double
            globals.assign(name: arg1.value as! String,value: argReturn)
            
          } else if (arguments[1] is Expr.SList) {
            var argReturn : Any
            let arg2 = arguments[1] as! Expr.SList
            argReturn = evaluate(expr: arg2)    
            globals.assign(name: arg1.value as! String,value: argReturn) 
                
          } else {
            var argReturn : Any
            let arg2 = arguments[1] as! Expr.Literal
            argReturn = arg2.value   
            globals.assign(name: arg1.value as! String,value: argReturn)     
          }

           case "cons":
           arguments = prepareSListExpr(tempArray: arguments)
           var cells = [Any]()
           if arguments[0] is Expr.Symbol{
             return fatalError("CANNOT ADD AN UNIDENTIFIED SYMBOL TO CONS CELL")
           } else {
             let temp = arguments[0]
             cells.append(temp)
           }
           if arguments[1] is Expr.Symbol{
             return fatalError("CANNOT ADD AN UNIDENTIFIED SYMBOL TO CONS CELL")
           } else {
             let temp = arguments[1]
             cells.append(temp)
           }
           return cells

           case "list":
           arguments = prepareSListExpr(tempArray: arguments)
           var list = [Any]()
           for arg in arguments {
             if arg is Expr.Symbol {
               return fatalError("CANNOT ADD AN UNIDENTIFIED SYMBOL TO CONS CELL")
             }
             list.append(arg)   
           }

           return list

           case "list-ref":
           arguments = prepareSListExpr(tempArray: arguments)

           var refVal = [Any?]()
           let index = arguments[1] as! Double
           refVal = arguments[0] as! Array<Any?>
           var refReturn = [Any]()
           for i in 0..<refVal.count {
             refReturn.append(refVal[i]!)
           }

           return refReturn[Int(index)]

           case "car":
           arguments = prepareSListExpr(tempArray: arguments)
           var carVal = [Any?]()
           carVal = arguments[0] as! Array<Any?>

           return carVal[0]!

           case "cdr":
           arguments = prepareSListExpr(tempArray: arguments)
           var cdrVal = [Any?]()
           cdrVal = arguments[0] as! Array<Any?>
           var cdrReturn = [Any]()

           for i in 1..<cdrVal.count {
             cdrReturn.append(cdrVal[i]!)
           }

           return cdrReturn

           case "lambda":
           let args = arguments[0] as! Expr.SList
           let proc = Procedure(args: args.expression, exp: arguments[1] as! Expr.SList)

           return proc

           case "let":
           var vars = [Any]()
           var vals = [Any]()

           var bindings = expr.expression[1] as! Expr.SList

           for binding in bindings.expression {
             let b = binding as! Expr.SList
             vars.append(b.expression[0])
             vals.append(b.expression[1])
           }

           var proc = Procedure(args: vars , exp: expr.expression[2] as! Expr.SList)

           proc.call(vars: vals)

           case "cond":
           for args in arguments {
             let temp = args as! Expr.SList
             if(temp.expression[0] is Expr.SList){
                let temp2 = temp.expression[0] as! Expr.SList
                let bool = evaluate(expr: temp2) as! Bool
                if(bool == true){
                  let tempReturn = evaluate(expr: temp.expression[1])
                  return tempReturn
                }
             }     
           }

           case "if":
           if arguments.count == 2 {
             let arg1 = arguments[0] as! Expr.SList
             let arg2 = arguments[1] as! Expr.SList
            
             let bool = evaluate(expr: arg1) as! Bool
             if bool == true {
               let tempReturn = evaluate(expr: arg2)
               return tempReturn
             }
           }

           if arguments.count == 3 {
             let arg1 = arguments[0] as! Expr.SList
             let arg2 = arguments[1] as! Expr.SList
             let arg3 = arguments[2] as! Expr.SList

             let bool = evaluate(expr: arg1) as! Bool
             if bool == true {
               let tempReturn = evaluate(expr: arg2)
               return tempReturn
             } else {
               let tempReturn2 = evaluate(expr: arg3)
               return tempReturn2
             }
           }
          
           case "define":

            if (arguments[0] is Expr.SList) {

             var finalArgs = [Any]()

             let finalExp = arguments[1] as! Expr.SList
          
             let args = arguments[0] as! Expr.SList
             let temp = args.expression 
             let name = temp[0] as! Expr.Symbol
             let finalName = name.value as! String

             for i in 1..<temp.count {
               finalArgs.append(temp[i])
             }

             let temp2 = finalExp.expression[0] as! Expr.Symbol
             let temp3 = temp2.value 
             let globalValues = globals.values
             if globalValues.index(forKey: temp3 as! String) != nil {
               if finalExp.expression[1] is Expr.Literal {
                 let literalInput = evaluate(expr: finalExp)
                 globals.define(name: finalName, value: literalInput)
               } else {
                 var temp3 = globals.get(key: temp3 as! String) as! Procedure
                 let newBody = temp3.body
                 let newArgs = temp3.parms
                 let proc = Procedure(args: newArgs , exp: newBody as! Expr.SList)
                 globals.define(name: finalName, value: proc)                
               }
              
              
            } else {
               let proc = Procedure(args: finalArgs, exp: finalExp)
               globals.define(name: finalName, value: proc)
            }
     

            } else {
             
             if (arguments[1] is Expr.Symbol) {
              arguments[1] = visitSymbolExpr(arguments[1] as! Expr.Symbol)
             } else if (arguments[1] is Expr.SList) {
              arguments[1] = visitSListExpr(arguments[1] as! Expr.SList)
             }

             if (arguments.count > 2) {
               return fatalError("define: arity mismatch")
             }

             if (!(arguments[0] is Expr.Symbol)) {
              return fatalError("define: must begin with a symbol")
             }

        let arg1 = arguments[0] as! Expr.Symbol
        let arg2 = arguments[1] as! Expr.Literal
        globals.define(name: arg1.value as! String, value: arg2.value)
      }

          default:            
            print(first)
        }      
        return nil
    }


    func prepareSListExpr(tempArray: Array<Any>) -> Array<Any> {
      var inputArray = tempArray
      var finalArray = [Any]()
      for i in 0..<inputArray.count {
        if inputArray[i] is Expr.Literal{
         let temp = evaluate(expr: inputArray[i] as! Expr)        
         finalArray.append(temp)
        }
        if inputArray[i] is Expr.Symbol{
          let temp = evaluate(expr: inputArray[i] as! Expr) 
          finalArray.append(temp)
        } else if inputArray[i] is Expr.SList {
          let temp = evaluate(expr: inputArray[i] as! Expr)
          finalArray.append(temp)
        }
      }
      return finalArray
    }

    class Procedure: Interpreter{
      var parms = [Any]()
      var body: Expr

      init(args: Array<Any>, exp: Expr.SList ){
        self.parms = args
        self.body = exp
      }

      init(args: Array<Any>, exp: Expr.Literal){
        self.parms = args
        self.body = exp
      }

      func call(vars: Array<Any>){
        let env = Environment()
        // var env = globals
        for i in 0..<parms.count {
          let temp = parms[i] as! Expr.Symbol
          let temp2 = temp.value as! String
          let var2 = vars[i] as! Expr
          let var3 = evaluate(expr: var2)
          env.define(name: temp2, value: var3) 
        }
          executeEnv(expression: body, environment: env)
        }
    }
}

 