//
//  ToDoItemRequest.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 28.09.2024.
//

import Foundation

// MARK: Get List
struct ToDoListGetRequest: Encodable {}

// MARK: - Upload
struct ToDoListUploadRequest: Encodable {
    let list: [ToDoItemUploadRequest]
}

struct ToDoItemUploadRequest: Encodable {
    let text: String
    let state: Bool
}

// MARK: - Create
struct ToDoItemCreateRequest: Encodable {
    let text: String
}

// MARK: - State
struct ToDoItemStateRequest: Encodable {
    let id: Int
}

// MARK: - Edit
struct ToDoItemEditRequest: Encodable {
    let id: Int
    let text: String
}

// MARK: - Delete
struct ToDoItemDeleteRequest: Encodable {
    let id: Int
}
