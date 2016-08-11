import Vapor
import HTTP



let drop = Droplet()


// 主路径
drop.get("/") { request in
    return try drop.view("welcome.html")
}


// GET 获取 URL Parameter 参数
drop.get("geturlParameter") { request in
    print(request)
    guard let name = request.data["name"].string else {
        throw Abort.badRequest
    }
    guard let age = request.data["age"]?.int else {
        throw Abort.badRequest
    }
    return try JSON([
        "name": name,
        "age": age
        ])
    
}

// GET 获取 body 参数
drop.post("getbody") { request in
    print(request.body.bytes)
    guard let name = request.data["name"].string else {
        throw Abort.badRequest
    }
    guard let age = request.data["age"]?.int else {
        throw Abort.badRequest
    }
    return try JSON([
        "name": name,
        "age": age
        ])
    
}
// POST 接口
drop.post("getpost") { request in
    print(request)
    guard let name = request.data["name"]?.string else {
        throw Abort.badRequest
    }
    guard let age = request.data["age"]?.int else {
        throw Abort.badRequest
    }
    return try JSON([
        "name": name,
        "age": age
        ])
    
}

// ＝＝＝＝＝  测试接口  ＝＝＝＝＝＝＝＝ //
// POST请求
drop.post("form") { request in
    return "Submitted With a POST request"
    
}
// 多路径请求
drop.get("foo", "bar", "baz") { request in
    return "You requested /foo/bar/baz"
}

// 重定向
drop.get("vapor") { request in
    return Response(redirect: "http://vapor.codes")
}
// 类型安全
// http://127.0.0.1:8080/typesafe1/123
// return You requested User #123
drop.get("typesafe1", Int.self) { request, userId in
    return "You requested User #\(userId)"
}

/// http://127.0.0.1:8080/typesafe2/123
/// return You requested User #123
drop.get("typesafe2", ":id") { request in
    print("typesafe2接口")
    guard let userId = request.parameters["id"].int else {
        throw Abort.badRequest
    }
    
    return "You requested User #\(userId)"
}
// 字符串 初始化
drop.get("stringinit", User.self) { request, user in
    return "You requested \(user.name)"
}
// ＝＝＝＝＝  测试接口  ＝＝＝＝＝＝＝＝ //
// 返回一个 JSON
drop.get("json") { request in
    return try JSON([
        "number": 123,
        "string": "test",
        "array": try JSON([
            0, 1, 2, 3
        ]),
        "dict": try JSON([
            "name": "Vapor",
            "lang": "Swift"
        ])
    ])
}


let users = UserController(droplet: drop)
drop.resource("users", users)


//class Name: ValidationSuite {
//    static func validate(input value: String) throws {
//        let evaluation = OnlyAlphanumeric.self
//            && Count.min(5)
//            && Count.max(20)
//
//        try evaluation.validate(input: value)
//    }
//}
//
///**
//    By using `Valid<>` properties, the
//    employee class ensures only valid
//    data will be stored.
//*/
//class Employee {
//    var email: Valid<Email>
//    var name: Valid<Name>
//
//    init(request: Request) throws {
//        email = try request.data["email"].validated()
//        name = try request.data["name"].validated()
//    }
//}
//
///**
//    Allows any instance of employee
//    to be returned as Json
//*/
//extension Employee: JSONRepresentable {
//    func makeJSON() throws -> JSON {
//        return try JSON([
//            "email": email.value,
//            "name": name.value
//        ])
//    }
//}

// 中间件
drop.middleware.append(SampleMiddleware())


drop.serve()
