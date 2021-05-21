//
//  Login.swift
//  Doro
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 codesrbit. All rights reserved.
//

import Foundation

// MARK: - Login
struct Userss: Decodable {
    let status: Bool
    let data: [LoginData1]
}

// MARK: - EmployeeData
struct LoginData1: Decodable {
    let id: Int
    let name, email: String
}
