//
//  Request.swift
//  TFLCodeApp
//
//  Created by Tanveer Ashraf on 12/11/2023.
//

import Foundation

enum Method: String {
    case get = "GET"
}

struct Request<Value> {
    var method: Method
    var path: String

    init(method: Method = .get, path: String) {
        self.method = method
        self.path = path
    }
}
