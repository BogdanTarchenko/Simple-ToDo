//
//  ToDoListViewControllerConfigure.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 02.09.2024.
//

import UIKit
import SnapKit

extension ToDoListViewController {
    func configureHeader() {
        self.header.isUserInteractionEnabled = true
        
        self.header.image = UIImage(named: "ToDoHeader")
        
        self.header.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
    }
    
    func configureTitleLabel() {
        self.titleLabel.text = "Мой список дел"
        self.titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = .white
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func configureToDoMakerView() {
        self.toDoMakerView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
    }
    
    func configureToDoTableView() {
        self.toDoTableView.snp.makeConstraints { make in
            make.top.equalTo(toDoMakerView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureImportButton() {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Импорт"
        buttonConfig.titlePadding = 20
        buttonConfig.baseBackgroundColor = .white
        buttonConfig.baseForegroundColor = .accent
        buttonConfig.buttonSize = .large
        
        self.importButton.configuration = buttonConfig
        self.importButton.layer.cornerRadius = 10
        
        self.importButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(80)
        }
        
        self.importButton.addTarget(self, action: #selector(importButtonTapped), for: .touchUpInside)
    }
    
    func configureExportButton() {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Экспорт"
        buttonConfig.titlePadding = 20
        buttonConfig.baseBackgroundColor = .white
        buttonConfig.baseForegroundColor = .accent
        buttonConfig.buttonSize = .large
        
        self.exportButton.configuration = buttonConfig
        self.exportButton.layer.cornerRadius = 16
        
        self.exportButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(80)
        }
        
        self.exportButton.addTarget(self, action: #selector(exportButtonTapped), for: .touchUpInside)
    }
}
