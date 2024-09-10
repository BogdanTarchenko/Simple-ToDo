//
//  ToDoItem.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 08.09.2024.
//

protocol ToDoItemProtocol {
    mutating func changeTitle(title: String)
    mutating func changeCategory(category: Category)
    mutating func changeState()
}

struct ToDoItem: ToDoItemProtocol, Codable {
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
