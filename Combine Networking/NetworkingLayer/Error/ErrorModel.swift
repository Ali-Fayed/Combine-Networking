//
//  ErrorModel.swift
//  MVVM-Clean
//
//  Created by Ali Fayed on 15/02/2023.
//

import Foundation
struct APIError: Error, Codable {
    let code: Int
    let message: String
}
