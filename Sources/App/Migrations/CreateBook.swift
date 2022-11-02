//
//  CreateBook.swift
//  
//
//  Created by Семен Безгин on 15.09.2022.
//

import Fluent

struct CreateBook: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("books")
            .id()
            .field(.title, .string, .required)
//            .field("author", .array(of: .string), .required)
            .field("author", .string, .required)
            .field("year", .int, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("books")
            .delete()
    }
}
