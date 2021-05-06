import Foundation

final class Environment{
    final var enclosing: Environment?

    var values = Dictionary<String, Any>()

    init() {
        enclosing = nil
    }

    init(enclosing: Environment) {
        self.enclosing = enclosing
    }

    func define(name: String, value: Any) {
        values[name] = value
    }

    func assign(name: String, value: Any){
      let key = name as! String
        if values.index(forKey: key) != nil {
        values[name] = value
        return
      }
        if let enclosing = enclosing {
            enclosing.assign(name: name, value: value)
            return
        }
        fatalError("Unidentified variable \(name)") 
    }

    func get (key: String) -> Any {
      if values.index(forKey: key) != nil {
        let key1 = values[key]
        return key1.unsafelyUnwrapped
      }
       if let enclosing = enclosing {        
         return enclosing.get(key: key)
      } 
      print("KEY")
      print(key)
       return fatalError("SYMBOL DOES NOT EXIST")
      
    }

    func toString() {  
      for value in values{
        print(value)
      }       
    }
    
}
