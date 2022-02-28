//
//  LoginResponse.swift
//  Account
//
//  Created by 方昱恒 on 2022/2/28.
//

//   let loginResponse = try? newJSONDecoder().decode(LoginResponse.self, from: jsonData)

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    var status: Int?
    var data: DataClass?
    var message: String?
}

// MARK: - DataClass
struct DataClass: Codable {
    var tokenString: String?
}
