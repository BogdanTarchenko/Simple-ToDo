//
//  BaseViewController.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 02.09.2024.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if navigationController?.viewControllers.first != self {
            setupCustomBackButton()
        }
    }
}

// MARK: CustomBackButton Setup Method
private extension BaseViewController {
    func setupCustomBackButton() {
        let customBackButton = UIButton(type: .custom)
        customBackButton.setImage(UIImage(named: "BackButton"), for: .normal)
        customBackButton.addTarget(self, action: #selector(customBackButtonTapped), for: .touchUpInside)
        
        let customBackBarButtonItem = UIBarButtonItem(customView: customBackButton)
        navigationItem.leftBarButtonItem = customBackBarButtonItem
    }
}

// MARK: - OnTap method
private extension BaseViewController {
    @objc func customBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
