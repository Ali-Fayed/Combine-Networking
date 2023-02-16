//
//  ErrorModel.swift
//  Combine Networking
//
//  Created by Ali Fayed on 15/02/2023.
//

import Foundation
struct APIError: Error, Codable {
    let message: String
}
