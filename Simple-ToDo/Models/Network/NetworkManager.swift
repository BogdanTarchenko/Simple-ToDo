//
//  NetworkManager.swift
//  Simple-ToDo
//
//  Created by Богдан Тарченко on 28.09.2024.
//

import Foundation
import UIKit

// MARK: - Network Manager
final class NetworkManager {

    func fetch<T: Decodable, U: Encodable>(api: Api, requestBody: U?, resultType: T.Type, completion: @escaping (Result<T, CustomError>) -> Void) {
        
        let urlString = api.baseURL + api.endpoint
        guard let url = URL(string: urlString) else {
            completion(.failure(.urlNotValid))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        
        switch api.method {
        case .post, .patch, .delete:
            do {
                if let requestBody = requestBody {
                    urlRequest.httpBody = try JSONEncoder().encode(requestBody)
                }
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.decodingError))
                return
            }
        case .get:
            break
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                if T.self == String.self {
                    let responseString = String(data: data, encoding: .utf8) ?? ""
                    completion(.success(responseString as! T))
                } else {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(response))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }

    // MARK: - Upload List
    func uploadList(list: [ToDoItemUploadRequest], completion: @escaping (Result<String, CustomError>) -> Void) {
        let api = Api.upload(list: list)
        fetch(api: api, requestBody: list, resultType: String.self, completion: completion)
    }

    // MARK: - Create Item
    func createItem(text: String, completion: @escaping (Result<ToDoItemCreateResponse, CustomError>) -> Void) {
        let request = ToDoItemCreateRequest(text: text)
        let api = Api.create(text: text)
        fetch(api: api, requestBody: request, resultType: ToDoItemCreateResponse.self, completion: completion)
    }

    // MARK: - Update State
    func updateItemState(id: Int, completion: @escaping (Result<ToDoItemStateResponse, CustomError>) -> Void) {
        let request = ToDoItemStateRequest(id: id)
        let api = Api.state(id: id)
        fetch(api: api, requestBody: request, resultType: ToDoItemStateResponse.self, completion: completion)
    }

    // MARK: - Edit Item
    func editItem(id: Int, text: String, completion: @escaping (Result<ToDoItemEditResponse, CustomError>) -> Void) {
        let request = ToDoItemEditRequest(id: id, text: text)
        let api = Api.edit(id: id, text: text)
        fetch(api: api, requestBody: request, resultType: ToDoItemEditResponse.self, completion: completion)
    }

    // MARK: - Delete Item
    func deleteItem(id: Int, completion: @escaping (Result<String, CustomError>) -> Void) {
        let request = ToDoItemDeleteRequest(id: id)
        let api = Api.delete(id: id)
        fetch(api: api, requestBody: request, resultType: String.self, completion: completion)
    }
    
    // MARK: - Get List
    func getList(completion: @escaping (Result<[ToDoItemGetResponse], CustomError>) -> Void) {
        let request = ToDoListGetRequest()
        let api = Api.list
        fetch(api: api, requestBody: request, resultType: [ToDoItemGetResponse].self, completion: completion)
    }
}

