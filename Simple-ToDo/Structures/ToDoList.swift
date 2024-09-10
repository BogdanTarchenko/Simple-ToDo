//
//  ToDoList.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 08.09.2024.
//

protocol ToDoListProtocol {
    func getNumberOfToDoItems() -> Int
    mutating func addToDoItem(item: ToDoItem)
    mutating func deleteToDoItem(index: Int)
    mutating func changeToDoItemTitle(index: Int, title: String)
    mutating func changeToDoItemCategory(index: Int, category: Category)
    mutating func changeToDoItemState(index: Int)
}

struct ToDoList: ToDoListProtocol {
    var toDoList: [ToDoItem]
}

extension ToDoList {
    func getNumberOfToDoItems() -> Int {
        return self.toDoList.count
    }
    
    mutating func addToDoItem(item: ToDoItem) {
        self.toDoList.append(item)
    }
    
    mutating func deleteToDoItem(index: Int) {
        self.toDoList.remove(at: index)
    }
    
    mutating func changeToDoItemTitle(index: Int, title: String) {
        self.toDoList[index].changeTitle(title: title)
    }
    
    mutating func changeToDoItemCategory(index: Int, category: Category) {
        self.toDoList[index].changeCategory(category: category)
    }
    
    mutating func changeToDoItemState(index: Int) {
        self.toDoList[index].changeState()
    }
}
