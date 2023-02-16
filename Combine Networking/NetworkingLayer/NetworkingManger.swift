//
//  SessionManager.swift
//  MVVM-Clean
//
//  Created by Ahmed Fathy on 10/01/2023.
//

import Foundation
import Combine
public final class NetworkingManger {
    private init() {}
    public static var shared = NetworkingManger()
    private var requestBuilder = RequestBuilder.shared
    private var subscribtions = Set<AnyCancellable>()
    private let decoder = JSONDecoder()
    func performRequest<T: Codable>(router: BaseRouter, model: T.Type, shouldCache: Bool = true) -> AnyPublisher<T, APIError>{
        return Future { [unowned self] promise in
            URLSession.shared.dataTaskPublisher(for: requestBuilder.buildRequest(router, shouldCache: shouldCache))
               .retry(1)
               .tryMap { dataElement -> Data in
                   if let httpResponse = dataElement.response as? HTTPURLResponse, let url = httpResponse.url {
                       let statusCode = httpResponse.statusCode
                       print("URL: [\(url)] , code: [\(statusCode)]")
                       guard statusCode < 500 else {
                            throw APIError(message: "Server is unavailable")
                       }
                       if 400..<500 ~= statusCode {
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
                   print(finished)
               } receiveValue: { data in
                   promise(.success(data))
               }.store(in: &subscribtions)
        }.eraseToAnyPublisher()
    }
}
