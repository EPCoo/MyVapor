import Vapor
import Fluent

extension Model {
    func makeResult(_ number:Int = 0) throws -> JSON  {
        return try JSON.object(["data" : self.makeJSON(),"code":JSON.number(Node.Number(number))])
    }
}
