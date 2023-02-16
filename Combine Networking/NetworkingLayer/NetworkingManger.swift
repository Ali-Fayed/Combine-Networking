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
    func performRequest<T: Codable>(router: BaseRouter, model: T.Type, shouldCache: Bool = true) -> AnyPublisher<T, Error>{
        return Future { [unowned self] promise in
            URLSession.shared.dataTaskPublisher(for: requestBuilder.buildRequest(router, shouldCache: shouldCache))
               .retry(1)
               .tryMap { dataElement -> Data in
                   guard let httpResponse = dataElement.response as? HTTPURLResponse,
                       (200...299).contains(httpResponse.statusCode) else {
                       throw URLError(.badServerResponse)
                   }
                   print("URL: \(String(describing: httpResponse.url)), code: \(httpResponse.statusCode)")
                   return dataElement.data
               }
               .decode(type: model.self, decoder: decoder)
               .mapError { error -> APIError in
                   if let urlError = error as? URLError {
                       return APIError(code: urlError.errorCode, message: urlError.localizedDescription)
                   } else {
                       return APIError(code: 0, message: "Unknown error occurred")
                   }
               }
               .receive(on: RunLoop.main)
               .sink { finished in
                   print(finished)
               } receiveValue: { data in
                   promise(.success(data))
               }.store(in: &subscribtions)
        }.eraseToAnyPublisher()
    }
    
}
