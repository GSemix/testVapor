//
//  Book.swift
//  
//
//  Created by Семен Безгин on 15.09.2022.
//

import Vapor
import Fluent
import Foundation

extension FieldKey {
    static var title: Self { "title" }
}

final class Book: Model, Content {
    
    static var schema: String = "books"
    
    @ID var id: UUID?
    
    @Field(key: .title)
    var title: String
    
    @Field(key: "author")
//    var author: [String]
    var author: String
    
    @Field(key: "year")
    var year: Int
    
//    @OptionalField(key: "test")
//    var test: String?
    
    init() {}
    
//    init(id: UUID? = nil, title: String, author: [String], year: Int) {
    init(id: UUID? = nil, title: String, author: String, year: Int) {
        self.id = id
        self.title = title
        self.author = author
        self.year = year
    }
}

//extension Book: Content {}
