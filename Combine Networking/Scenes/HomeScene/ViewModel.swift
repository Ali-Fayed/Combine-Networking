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
    let usersPublisher = PassthroughSubject<[User], APIError>()
    init() {
        fetchData()
    }
    func fetchData() {
        let request =  NetworkingManger.shared.performRequest(router: RequestRouter.users, model: [User].self, shouldCache: false)
        request.sink { completion in
            switch completion {
            case .failure(let error):
                self.usersPublisher.send(completion: .failure(error))
            case .finished:
                break
            }
        } receiveValue: { users in
            DispatchQueue.main.async {
                self.usersPublisher.send(users)
            }
        }.store(in: &subscribtions)
    }
}
