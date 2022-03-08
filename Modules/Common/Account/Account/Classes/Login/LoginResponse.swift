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
    var data: LoginData?
    var message: String?
}

// MARK: - DataClass
struct LoginData: Codable {
    var tokenString: String?
}

enum LoginStatusCode: Int {
    case ok     = 200
    case pwdErr = 602
}
