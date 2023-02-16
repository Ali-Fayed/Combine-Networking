//
//  ViewModel.swift
//  Combine Networking
//
//  Created by Ali Fayed on 16/02/2023.
//
import Foundation
import Combine
class ViewModel {
    private var subscribtions = Set< AnyCancellable > ()
    func fetch() {
        let request =  NetworkingManger.shared.performRequest(router: RequestRouter.users, model: [User].self, shouldCache: false)
        request.sink { completion in
            switch completion {
            case .failure(let error):
                print(error.message)
            case .finished:
                break
            }
        } receiveValue: { value in
            print(value)
        }.store(in: &subscribtions)
    }
}
