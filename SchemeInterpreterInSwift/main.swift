import Foundation

let file = "Scheme.txt"

let contents = try! String(contentsOfFile: file)

var scanner = Scanner(source: contents)
var parserInput = scanner.scanTokens()

print("Scanner: ---------->")

for tokens in scanner.tokens {
	print(tokens)
}
print()

// print("Parser: ---------->")

var parser = Parser(tokens: parserInput)
var finalParse = parser.parse()
for parse in finalParse{
	if let parse = parse{  
		// print(parse)
	}
}

print()

print("Interpreter: ---------->")


var interpreter = Interpreter()

interpreter.interpret(finalParse)





