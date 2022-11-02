//
//  File.swift
//  
//
//  Created by Семен Безгин on 16.09.2022.
//

import Fluent
import Vapor

struct BooksController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let booksRoutes = routes.grouped("api", "books")
        
        booksRoutes.get(use: getAllHandler)
        booksRoutes.get(["id", ":arg"], use: getHandlerId)
        booksRoutes.post(use: createHandler)
        booksRoutes.put(["id", ":arg"], use: updateHandlerId)
        booksRoutes.delete(["id", ":arg"], use: deleteHandlerId)
        booksRoutes.get(["title", ":arg"], use: getHandlerTitle)
    }
    
    // CRUD - Retrieve (Получение книг)
    func getAllHandler(_ req: Request) -> EventLoopFuture<[Book]> {
        Book.query(on: req.db).all()
    }
    
    // CRUD - Retrieve (Получение книги по ID)
    func getHandlerId(_ req: Request) -> EventLoopFuture<Book> {
        Book.find(req.parameters.get("arg"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // CRUD - Retrieve (Получение книги по Title)
    func getHandlerTitle(_ req: Request) -> EventLoopFuture<Book> {
        Book.query(on: req.db)
            .filter(\.$title == req.parameters.get("arg") ?? "")
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    // CRUD - Create (Создание книги)
    func createHandler(_ req: Request) throws -> EventLoopFuture<Book> {
        let book = try req.content.decode(Book.self)
        
        return book.save(on: req.db).map{ book }
    }
    
    // CRUD - Update (Обновление книги по ID)
    func updateHandlerId(_ req: Request) throws -> EventLoopFuture<Book> {
        let updatedBook = try req.content.decode(Book.self)
        
        return Book.find(req.parameters.get("arg"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { book in
                book.title = updatedBook.title
                book.author = updatedBook.author
                book.year = updatedBook.year
                
                return book.save(on: req.db).map{book}
            }
    }
    
    // CRUD - Delete (Удаление книги по ID)
    func deleteHandlerId(_ req: Request) -> EventLoopFuture<HTTPStatus> {
        Book.find(req.parameters.get("arg"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { book in
                book.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}
