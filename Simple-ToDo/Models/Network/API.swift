//
//  API.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 28.09.2024.
//

import Foundation

// MARK: - API
enum Api {
    enum Method {
        case get
        case post(request: Encodable)
        case patch(request: Encodable)
        case delete(request: Encodable)
        
        var rawValue: String {
            switch self {
            case .get:      return "GET"
            case .post:     return "POST"
            case .patch:    return "PATCH"
            case .delete:   return "DELETE"
            }
        }
    }
    
    case list
    case upload(list: [ToDoItemUploadRequest])
    case create(text: String)
    case state(id: Int)
    case edit(id: Int, text: String)
    case delete(id: Int)
    
    var endpoint: String {
        switch self {
        case .list:             return "list"
        case .upload:           return "list/upload"
        case .create:           return "item/create"
        case .state:            return "item/state"
        case .edit:             return "item/edit"
        case .delete:           return "item/delete"
        }
    }
    
    var method: Method {
        switch self {
        case .list:                                     return .get
        case .upload(let list):                         return .post(request: ToDoListUploadRequest(list: list))
        case .create(let text):                         return .post(request: ToDoItemCreateRequest(text: text))
        case .state(let id):                            return .patch(request: ToDoItemStateRequest(id: id))
        case .edit(let id, let text):                   return .patch(request: ToDoItemEditRequest(id: id, text: text))
        case .delete(let id):                           return .delete(request: ToDoItemDeleteRequest(id: id))
        }
    }
    
    var baseURL: String {
        return "http://127.0.0.1:8000/api/"
    } 
}
