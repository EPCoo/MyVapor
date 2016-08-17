import Vapor
import VaporMySQL

let mysql = try VaporMySQL.Provider(host: "localhost", user: "test", password: "123", database: "test")
let version = try mysql.driver.raw("SELECT @@version")

print(version)


let drop = Droplet(preparations: [Dog.self],initializedProviders:[mysql])

// 主路径
drop.get("/") { request in
    return "hello swift"
}


// POST 返回Model
drop.post("postname") { request in
//    print(request)
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    var ddd = Dog(name:name)
    try ddd.save()
    
    return try ddd.makeResult(1)
}


drop.serve()
