//
//  NetworkingManger.swift
//  Combine Networking
//
//  Created by Ali Fayed on 15/02/2023.
//
import Foundation
import Combine
public final class NetworkingManger {
    private init() {}
    public static var shared = NetworkingManger()
    private var subscribtions = Set<AnyCancellable>()
    private let decoder = JSONDecoder()
    /// Network Layer description
    /// - Parameters:
    ///   - router: paramater give the request the main URLRequest components.
    ///   - model: the model will return.
    ///   - shouldCache: a bool to check if we want to cache the reponse or not
    /// - Returns: a Publisher contatins model and error.
    func performRequest<T: Codable>(router: BaseRouter, model: T.Type, shouldCache: Bool = true) -> AnyPublisher<T, APIError>{
        return Future { [unowned self] promise in
            guard NetworkReachability.isConnectedToNetwork() else {
                return promise(.failure(APIError(.noConnetion)))
            }
            let requestRouter = router.asURLRequest(shouldCache: shouldCache)
            URLSession.shared.dataTaskPublisher(for: requestRouter)
               .retry(1)
               .tryMap { dataElement -> Data in
                   if let httpResponse = dataElement.response as? HTTPURLResponse, let url = httpResponse.url {
                       let statusCode = httpResponse.statusCode
                       print("URL: [\(url)] , code: [\(statusCode)]")
                       guard statusCode < 500 else {
                           throw APIError(.serverError)
                       }
                       if 400..<499 ~= statusCode {
                            let error = try JSONDecoder().decode(APIError.self, from: dataElement.data)
                            throw error
                       }
                       guard (200...299).contains(statusCode) else {
                           throw URLError(.badServerResponse)
                       }
                   }
                   return dataElement.data
               }
               .decode(type: model.self, decoder: decoder)
               .receive(on: RunLoop.main)
               .sink { finished in
                   switch finished {
                   case .failure:
                       promise(.failure(APIError(.decodingError)))
                   case .finished:
                       break
                   }
               } receiveValue: { data in
                   promise(.success(data))
               }.store(in: &subscribtions)
        }.eraseToAnyPublisher()
    }
}
