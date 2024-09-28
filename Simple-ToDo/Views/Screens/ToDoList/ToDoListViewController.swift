import UIKit

class ToDoListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    let networkManager = NetworkManager()
    
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

// MARK: - ToDoMakerViewDelegate Methods
extension ToDoListViewController: ToDoMakerViewDelegate {
    func didEditToDoItem(title: String, category: Category, at indexPath: IndexPath) {
        let item = toDoList.toDoList[indexPath.row]
        networkManager.editItem(id: item.id, text: title) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.toDoList.changeToDoItemTitle(index: indexPath.row, title: title)
                    self?.toDoList.changeToDoItemCategory(index: indexPath.row, category: category)
                    self?.toDoTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didAddToDoItem(title: String, category: Category) {
        networkManager.createItem(text: title) { [weak self] result in
            switch result {
            case .success(let response):
                let newToDoItem = ToDoItem(id: response.id, title: title, category: category, state: false)
                self?.toDoList.addToDoItem(item: newToDoItem)
                DispatchQueue.main.async {
                    self?.toDoTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - ToDoTableViewCellDelegate Methods
extension ToDoListViewController: ToDoTableViewCellDelegate {
    func didEditToDoItem(at indexPath: IndexPath) {
        let todoItem = toDoList.toDoList[indexPath.row]
        toDoMakerView.textField.text = todoItem.title
        toDoMakerView.state = .editingMode
        toDoMakerView.indexPath = indexPath
    }
    
    func didDeleteToDoItem(at indexPath: IndexPath) {
        let item = toDoList.toDoList[indexPath.row]
        networkManager.deleteItem(id: item.id) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.toDoList.deleteToDoItem(index: indexPath.row)
                    self?.toDoTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func didChangeStateToDoItem(at indexPath: IndexPath) {
        let item = toDoList.toDoList[indexPath.row]
        networkManager.updateItemState(id: item.id) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.toDoList.changeToDoItemState(index: indexPath.row)
                    self?.toDoTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
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
        networkManager.getList { [weak self] result in
            switch result {
            case .success(let response):
                let updatedItems = response.map { item in
                    ToDoItem(id: item.id, title: item.text, category: .goal, state: item.state)
                }
                self?.toDoList = ToDoList(toDoList: updatedItems)
                DispatchQueue.main.async {
                    self?.toDoTableView.reloadData()
                }
            case .failure(let error):
                print(error)
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
            
            for item in toDoItems {
                networkManager.createItem(text: item.title) { [weak self] result in
                    switch result {
                    case .success(let response):
                        let newToDoItem = ToDoItem(id: response.id, title: item.title, category: item.category, state: item.state)
                        self?.toDoList.addToDoItem(item: newToDoItem)
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.toDoTableView.reloadData()
            }
        } catch {
            print(error)
        }
        
        selectedFileURL.stopAccessingSecurityScopedResource()
    }
    
    
    @objc func exportButtonTapped() {
        let fileName = "ToDoList.json"
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        do {
            let data = try JSONEncoder().encode(toDoList.toDoList)
            try data.write(to: fileURL)
            
            let documentPicker = UIDocumentPickerViewController(forExporting: [fileURL])
            documentPicker.delegate = self
            documentPicker.allowsMultipleSelection = false
            present(documentPicker, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
}
