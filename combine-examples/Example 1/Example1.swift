//
//  Example1.swift
//  combine-examples
//
//  Created by Suman Nandi on 04/07/23.
//

/*
 Example of:
 - Future Publisher
 - URLSession DataTaskPublisher
 */

import Foundation
import Combine

/*
 VIEW MODEL
 */
class ExampleViewModel: ObservableObject {
    
    @Published var posts = [Post]()
    private var subscriptions = Set<AnyCancellable>()
    
    func getItemsFromService() async {
        NetworkManager.shared.getAllItems()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure :
                    print("Error: \(completion)")
                case .finished:
                    print("Finished: \(completion)")
                }
            }, receiveValue: { [weak self] posts in
                self?.posts = posts
            })
            .store(in: &subscriptions)
    }
}

/*
 MODEL
 */
struct Post: Decodable, Identifiable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

/*
 NEWTORK MANAGER
 */
enum APIError: Error {
    case invalidResponse
    case invalidStatusCode
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
    private var subscriptions = Set<AnyCancellable>()
    
    func getAllItems<T: Decodable>() -> Future<[T], APIError> {
        
        return Future<[T], APIError> { promise in
            URLSession.shared.dataTaskPublisher(for: self.url!)
                .tryMap { (data, response) -> Data in
                    guard let urlresponse = response as? HTTPURLResponse else {
                        throw APIError.invalidResponse
                    }
                    if !(200..<300).contains(urlresponse.statusCode) {
                        throw APIError.invalidStatusCode
                    }
                    return data
                }
                .decode(type: [T].self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure:
                        promise(.failure(APIError.decodingError))
                    default: break
                    }
                } receiveValue: { result in
                    promise(.success(result))
                }
                .store(in: &self.subscriptions)
        }
    }
}
