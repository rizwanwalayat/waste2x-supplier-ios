//
//  File.swift
//  Haid3r
//
//  Created by a on 02/10/2020.
//  Copyright © 2020 Haider Awan. All rights reserved.
//

import Foundation

class APIService :  NSObject {
    
    private let sourcesURL = URL(string: "http://dummy.restapiexample.com/api/v1/employees")!
    
    func apiToGetEmployeeData(completion : @escaping (String) -> ()){
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            if let data = data {
                
                let jsonDecoder = JSONDecoder()
                
                //let empData = try! jsonDecoder.decode(Employees.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    let loginData = "John Doe"
                    completion(loginData)
                }
            }
        }.resume()
    }
}
