//
//  ToDoTableViewCell.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 08.09.2024.
//

import UIKit
import SnapKit

protocol ToDoTableViewCellDelegate: AnyObject {
    func didChangeStateToDoItem(at indexPath: IndexPath)
    func didDeleteToDoItem(at indexPath: IndexPath)
    func didEditToDoItem(at indexPath: IndexPath)
}

class ToDoTableViewCell: UITableViewCell {
    
    weak var delegate: ToDoTableViewCellDelegate?
    var indexPath: IndexPath?
    
    var isCompleted: Bool
    var category: Category
    
    var categoryIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    var checkBoxButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var binButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var editButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.isCompleted = false
        self.category = .goal
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        self.isCompleted = false
        self.category = .goal
        super.init(coder: coder)
        self.setupView()
    }
}

// MARK: - Setup Methods
extension ToDoTableViewCell {
    func setupView() {
        contentView.addSubview(categoryIcon)
        self.configureImage()
        
        contentView.addSubview(checkBoxButton)
        self.configureCheckBox()
        
        contentView.addSubview(binButton)
        self.configureBin()
        
        contentView.addSubview(editButton)
        self.configureEditButton()
        
        contentView.addSubview(titleLabel)
        self.configureTitleLabel()
    }
}

// MARK: - Configure Methods
extension ToDoTableViewCell {
    func configureImage() {
        switch self.category {
        case .goal:
            self.categoryIcon.image = UIImage(named: "GoalCategory")
        case .study:
            self.categoryIcon.image = UIImage(named: "StudyCategory")
        case .time:
            self.categoryIcon.image = UIImage(named: "TimeCategory")
        }
        
        self.categoryIcon.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configureTitleLabel() {
        self.titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        self.titleLabel.textColor = .black
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(categoryIcon).inset(64)
            make.trailing.equalTo(editButton).inset(40)
        }
    }
    
    func configureCheckBox() {
        if (isCompleted) {
            self.checkBoxButton.setImage(UIImage(named: "FilledCheckBox"), for: .normal)
        } else {
            self.checkBoxButton.setImage(UIImage(named: "EmptyCheckBox"), for: .normal)
        }
        
        self.checkBoxButton.addTarget(self, action: #selector(checkBoxButtonTapped), for: .touchUpInside)
        
        self.checkBoxButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configureBin() {
        self.binButton.setImage(UIImage(systemName: "xmark.bin.fill"), for: .normal)
        self.binButton.tintColor = .accent
        
        self.binButton.addTarget(self, action: #selector(binButtonTapped), for: .touchUpInside)
        
        self.binButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(checkBoxButton).inset(40)
        }
    }
    
    func configureEditButton() {
        self.editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        self.editButton.tintColor = .accent
        
        self.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        self.editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(binButton).inset(40)
        }
    }
}

// MARK: - Edit Methods
extension ToDoTableViewCell {
    func changeCategory(category: Category) {
        self.category = category
        self.configureImage()
    }
    
    func changeTitle(title: String) {
        self.titleLabel.text = title
    }
    
    func changeState() {
        self.isCompleted = !self.isCompleted
        self.configureCheckBox()
    }
}

// MARK: Actions
extension ToDoTableViewCell {
    @objc func checkBoxButtonTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.didChangeStateToDoItem(at: indexPath)
    }
    
    @objc func binButtonTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.didDeleteToDoItem(at: indexPath)
    }
    
    @objc func editButtonTapped() {
        guard let indexPath = indexPath else { return }
        delegate?.didEditToDoItem(at: indexPath)
    }
}
