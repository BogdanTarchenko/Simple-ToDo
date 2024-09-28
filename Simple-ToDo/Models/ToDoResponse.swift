//
//  ToDoItemResponse.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 28.09.2024.
//

import Foundation

// MARK: - Get List
struct ToDoListGetResponse: Decodable {
    let list: [ToDoItemGetResponse]
}

struct ToDoItemGetResponse: Decodable {
    let id: Int
    let text: String
    let state: Bool
}

// MARK: - Create
struct ToDoItemCreateResponse: Decodable {
    let id: Int
    let text: String
}

// MARK: - State
struct ToDoItemStateResponse: Decodable {
    let id: Int
    let text: String
    let state: Bool
}

// MARK: - Edit
struct ToDoItemEditResponse: Decodable {
    let id: Int
    let text: String
    let state: Bool
}

// MARK: - Delete
struct ToDoItemDeleteResponse: Decodable {
    let msg: String
    let id: Int
    let text: String
    let state: Bool
}
