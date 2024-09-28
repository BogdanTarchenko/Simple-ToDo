//
//  ToDoItem.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 08.09.2024.
//

import Foundation

protocol ToDoItemProtocol {
    var id: Int { get set }
    var title: String { get set }
    var category: Category { get set }
    var state: Bool { get set }
}

struct ToDoItem: ToDoItemProtocol, Codable {
    var id: Int
    var title: String
    var category: Category
    var state: Bool
}


extension ToDoItem {
    mutating func changeTitle(title: String) {
        self.title = title
    }
    
    mutating func changeCategory(category: Category) {
        self.category = category
    }
    
    mutating func changeState() {
        self.state = !self.state
    }
}
