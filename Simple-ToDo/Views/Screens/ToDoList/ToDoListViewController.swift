//
//  ToDoListViewController.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 02.09.2024.
//

import UIKit

class ToDoListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    
    var header: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var importButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var exportButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var toDoMakerView = ToDoMakerView()
    
    let toDoTableView = UITableView()
    var toDoList = ToDoList(toDoList: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadToDoList()
        
        self.view.backgroundColor = .background
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.view.addSubview(header)
        self.configureHeader()
        
        self.header.addSubview(titleLabel)
        self.configureTitleLabel()
        
        self.header.addSubview(importButton)
        self.configureImportButton()
        self.header.addSubview(exportButton)
        self.configureExportButton()
        
        self.view.addSubview(toDoMakerView)
        toDoMakerView.delegate = self
        self.configureToDoMakerView()
        
        self.view.addSubview(toDoTableView)
        toDoTableView.delegate = self
        toDoTableView.dataSource = self
        toDoTableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: "ToDoCell")
        self.configureToDoTableView()
    }
}

// MARK: - UITableView Data Source Methods
extension ToDoListViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.getNumberOfToDoItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as? ToDoTableViewCell else {
            return UITableViewCell()
        }
        
        let todoItem = toDoList.toDoList[indexPath.row]
        
        cell.selectionStyle = .none
        cell.titleLabel.text = todoItem.title
        cell.category = todoItem.category
        cell.isCompleted = todoItem.state
        cell.indexPath = indexPath
        cell.delegate = self
        
        cell.configureImage()
        cell.configureCheckBox()
        cell.configureTitleLabel()
        
        return cell
    }
}

// MARK: - UITableView Delegate Method
extension ToDoListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - ToDoMakerViewDelegate Method
extension ToDoListViewController: ToDoMakerViewDelegate {
    func didEditToDoItem(title: String, category: Category, at indexPath: IndexPath) {
        toDoList.changeToDoItemTitle(index: indexPath.row, title: title)
        toDoList.changeToDoItemCategory(index: indexPath.row, category: category)
        toDoTableView.reloadData()
        
        saveToDoList()
    }
    
    func didAddToDoItem(title: String, category: Category) {
        let newToDoItem = ToDoItem(title: title, category: category, state: false)
        toDoList.addToDoItem(item: newToDoItem)
        toDoTableView.reloadData()
        
        saveToDoList()
    }
}

// MARK: - ToDoTableViewCellDelegate Method
extension ToDoListViewController: ToDoTableViewCellDelegate {
    func didEditToDoItem(at indexPath: IndexPath) {
        let todoItem = toDoList.toDoList[indexPath.row]
        toDoMakerView.textField.text = todoItem.title
        toDoMakerView.state = .editingMode
        toDoMakerView.indexPath = indexPath
        
        saveToDoList()
    }
    
    func didDeleteToDoItem(at indexPath: IndexPath) {
        toDoList.deleteToDoItem(index: indexPath.row)
        toDoTableView.reloadData()
        
        saveToDoList()
    }
    
    func didChangeStateToDoItem(at indexPath: IndexPath) {
        toDoList.changeToDoItemState(index: indexPath.row)
        toDoTableView.reloadData()
        
        saveToDoList()
    }
}

// MARK: - Keyboard Dismiss Method
extension ToDoListViewController {
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

// MARK: - Actions
extension ToDoListViewController {
    func saveToDoList() {
        if let encodedToDoList = try? JSONEncoder().encode(toDoList.toDoList) {
            defaults.set(encodedToDoList, forKey: KeyDefaults.todoList)
        }
    }
    
    func loadToDoList() {
        if let savedToDoListData = defaults.data(forKey: KeyDefaults.todoList) {
            if let decodedToDoList = try? JSONDecoder().decode([ToDoItem].self, from: savedToDoListData) {
                toDoList = ToDoList(toDoList: decodedToDoList)
                print(toDoList.toDoList)
            }
        }
    }
}

// MARK: - File Manager Actions
extension ToDoListViewController: UIDocumentPickerDelegate {
    @objc func importButtonTapped() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.json])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else { return }
        
        guard selectedFileURL.startAccessingSecurityScopedResource() else {
            return
        }
        
        do {
            let data = try Data(contentsOf: selectedFileURL)
            let toDoItems = try JSONDecoder().decode([ToDoItem].self, from: data)
            self.toDoList = ToDoList(toDoList: toDoItems)
            self.toDoTableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    @objc func exportButtonTapped() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentDirectory = urls.first else { return }
        let fileURL = documentDirectory.appendingPathComponent("todoList.json")
        
        do {
            let data = try JSONEncoder().encode(self.toDoList.toDoList)
            try data.write(to: fileURL)
            
            let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            present(activityViewController, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
}
