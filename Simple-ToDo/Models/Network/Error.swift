//
//  Error.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 28.09.2024.
//

import Foundation

// MARK: - Error
enum CustomError: Error {
    case urlNotValid
    case requestFailed
    case noData
    case decodingError
}
