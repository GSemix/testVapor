import Fluent
import Vapor

func routes(_ app: Application) throws {
    let booksController = BooksController()
    try app.register(collection: booksController)
    
    app.get { req async in
        "It works!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
    
    app.get("other") { req async -> String in
        "Other"
    }

    app.get("first", "second") { req -> String in
        return "First + Second"
    }

    app.get("NAME", ":name") { req -> String in
        guard let name = req.parameters.get("name") else {
            throw Abort(.internalServerError)
        }
        
        return "InputNAME: \(name)"
    }

    app.get("count", ":word") { req -> String in
        guard let word = req.parameters.get("word") else {
            throw Abort(.internalServerError)
        }
        
        return "Count characters in \"\(word)\": \(word.count)"
    }

    app.post("post") { req -> String in
        let data = try req.content.decode(Other.self)
        
        return "First: \(data.first)\nSecond: \(data.second)"
    }

    app.post("post", "json") { req -> ResponseOther in
        let data = try req.content.decode(Other.self)
        
        return ResponseOther(response: data)
    }
    
//    // CRUD - Create (Создание книги)
//    app.post("api", "books") { req -> EventLoopFuture<Book> in
//        let book = try req.content.decode(Book.self)
//
//        return book.save(on: req.db).map({book})
//    }
//
//    // CRUD - Retrieve (Получение книг)
//    app.get("api", "books") { req -> EventLoopFuture<[Book]> in
//        Book.query(on: req.db).all()
//    }
//
//    // CRUD - Retrieve (Получение книги по ID)
//    app.get("api", "books", ":bookID") { req -> EventLoopFuture<Book> in
//        Book.find(req.parameters.get("bookID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//    }
//
//    // CRUD - Update (Обновление книги по ID)
//    app.put("api", "books", ":bookID") { req -> EventLoopFuture<Book> in
//        let updatedBook = try req.content.decode(Book.self)
//        return Book.find(req.parameters.get("bookID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { book in
//                book.title = updatedBook.title
//                book.author = updatedBook.author
//                book.year = updatedBook.year
//
//                return book.save(on: req.db).map{book}
//            }
//    }
//
//    // CRUD - Delete (Удаление книги по ID)
//    app.delete("api", "books", ":bookID") { req -> EventLoopFuture<HTTPStatus> in
//        Book.find(req.parameters.get("bookID"), on: req.db)
//            .unwrap(or: Abort(.notFound))
//            .flatMap { book in
//                book.delete(on: req.db)
//                    .transform(to: .noContent)
//            }
//    }
}


struct Other: Content {
    let first: String
    let second: String
}

struct ResponseOther: Content {
    let response: Other
}
