//
//  ToDoMakerView.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 09.09.2024.
//

import UIKit
import SnapKit

protocol ToDoMakerViewDelegate: AnyObject {
    func didAddToDoItem(title: String, category: Category)
    func didEditToDoItem(title: String, category: Category, at indexPath: IndexPath)
}

class ToDoMakerView: UIView {
    
    weak var delegate: ToDoMakerViewDelegate?
    var indexPath: IndexPath?
    
    var state: ToDoMakerState
    
    var textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    var studyCategoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "StudyCategory"), for: .normal)
        return button
    }()
    
    var goalCategoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "GoalCategory"), for: .normal)
        return button
    }()
    
    var timeCategoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "TimeCategory"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        self.state = .addingMode
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        self.state = .addingMode
        super.init(coder: coder)
        self.setupView()
    }
}

// MARK: Configure Methods
extension ToDoMakerView {
    func configureTextField() {
        if (self.state == .addingMode) {
            self.textField.placeholder = "Название дела..."
        } else {
            self.textField.placeholder = "Новое название..."
        }
        
        self.textField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(200)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureStudyCategoryButton() {
        self.studyCategoryButton.addTarget(self, action: #selector(studyCategoryTapped), for: .touchUpInside)
        
        self.studyCategoryButton.snp.makeConstraints { make in
            make.leading.equalTo(textField.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureGoalCategoryButton() {
        self.goalCategoryButton.addTarget(self, action: #selector(goalCategoryTapped), for: .touchUpInside)
        
        self.goalCategoryButton.snp.makeConstraints { make in
            make.leading.equalTo(studyCategoryButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureTimeCategoryButton() {
        self.timeCategoryButton.addTarget(self, action: #selector(timeCategoryTapped), for: .touchUpInside)
        
        self.timeCategoryButton.snp.makeConstraints { make in
            make.leading.equalTo(goalCategoryButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
    }
}

// MARK: Setup Method
extension ToDoMakerView {
    func setupView() {
        self.addSubview(textField)
        self.configureTextField()
        
        self.addSubview(studyCategoryButton)
        self.configureStudyCategoryButton()
        
        self.addSubview(goalCategoryButton)
        self.configureGoalCategoryButton()
        
        self.addSubview(timeCategoryButton)
        self.configureTimeCategoryButton()
    }
}

// MARK: Actions
extension ToDoMakerView {
    @objc func studyCategoryTapped() {
        switch state {
        case .addingMode:
            guard let title = textField.text, !title.isEmpty else { return }
            delegate?.didAddToDoItem(title: title, category: .study)
            textField.text = ""
            textField.resignFirstResponder()
        case .editingMode:
            guard let title = textField.text, !title.isEmpty else { return }
            guard let indexPath = indexPath else { return }
            delegate?.didEditToDoItem(title: title, category: .study, at: indexPath)
            textField.text = ""
            textField.resignFirstResponder()
            self.state = .addingMode
        }
    }
    
    @objc func goalCategoryTapped() {
        switch state {
        case .addingMode:
            guard let title = textField.text, !title.isEmpty else { return }
            delegate?.didAddToDoItem(title: title, category: .goal)
            textField.text = ""
            textField.resignFirstResponder()
        case .editingMode:
            guard let title = textField.text, !title.isEmpty else { return }
            guard let indexPath = indexPath else { return }
            delegate?.didEditToDoItem(title: title, category: .goal, at: indexPath)
            textField.text = ""
            textField.resignFirstResponder()
            self.state = .addingMode
        }
    }
    
    @objc func timeCategoryTapped() {
        switch state {
        case .addingMode:
            guard let title = textField.text, !title.isEmpty else { return }
            delegate?.didAddToDoItem(title: title, category: .time)
            textField.text = ""
            textField.resignFirstResponder()
        case .editingMode:
            guard let title = textField.text, !title.isEmpty else { return }
            guard let indexPath = indexPath else { return }
            delegate?.didEditToDoItem(title: title, category: .time, at: indexPath)
            textField.text = ""
            textField.resignFirstResponder()
            self.state = .addingMode
        }
    }
}

